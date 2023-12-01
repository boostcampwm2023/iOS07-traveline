import {
  Injectable,
  ForbiddenException,
  NotFoundException,
} from '@nestjs/common';
import axios from 'axios';
import { CreateTimelineDto } from './dto/create-timeline.dto';
import { UpdateTimelineDto } from './dto/update-timeline.dto';
import { TimelinesRepository } from './timelines.repository';
import { Timeline } from './entities/timeline.entity';
import { StorageService } from '../storage/storage.service';
import { PostingsService } from '../postings/postings.service';
import { KAKAO_KEYWORD_SEARCH } from './timelines.constants';

@Injectable()
export class TimelinesService {
  constructor(
    private readonly timelinesRepository: TimelinesRepository,
    private readonly postingsService: PostingsService,
    private readonly storageService: StorageService
  ) {}

  async create(
    userId: string,
    file: Express.Multer.File,
    createTimelineDto: CreateTimelineDto
  ) {
    const posting = await this.postingsService.findOne(
      createTimelineDto.posting
    );

    if (posting.writer.id !== userId) {
      throw new ForbiddenException(
        '본인이 작성한 게시글에 대해서만 타임라인을 생성할 수 있습니다.'
      );
    }

    const timeline = await this.initialize(createTimelineDto);
    timeline.posting = posting;

    if (file) {
      const filePath = `${userId}/${posting.id}`;
      const { path } = await this.storageService.upload(filePath, file);
      timeline.image = path;
    }

    return this.timelinesRepository.save(timeline);
  }

  async findAll(postingId: string, day: number) {
    const timelines = await this.timelinesRepository.findAll(postingId, day);

    return Promise.all(
      timelines.map(async (timeline) => {
        const imageUrl = timeline.image
          ? await this.storageService.getImageUrl(timeline.image)
          : null;
        return {
          ...timeline,
          description: timeline.description + '...',
          image: imageUrl,
        };
      })
    );
  }

  async findOneWithURL(id: string) {
    const timeline = await this.findOne(id);

    if (timeline.image) {
      timeline.image = await this.storageService.getImageUrl(timeline.image);
    }

    return timeline;
  }

  async update(
    id: string,
    userId: string,
    image: Express.Multer.File,
    updateTimelineDto: UpdateTimelineDto
  ) {
    const timeline = await this.findOne(id);

    if (timeline.image) {
      await this.storageService.delete(timeline.image);
    }

    const updatedTimeline = await this.initialize(updateTimelineDto);
    updatedTimeline.id = id;

    if (image) {
      const imagePath = `${userId}/${id}`;
      const { path } = await this.storageService.upload(imagePath, image);
      updatedTimeline.image = path;
    }

    return this.timelinesRepository.update(id, updatedTimeline);
  }

  async remove(id: string) {
    const timeline = await this.findOne(id);

    if (timeline.image) {
      await this.storageService.delete(timeline.image);
    }

    return this.timelinesRepository.remove(timeline);
  }

  private async initialize(
    timelineDto: CreateTimelineDto | UpdateTimelineDto
  ): Promise<Timeline> {
    const timeline = new Timeline();
    Object.assign(timeline, timelineDto);
    return timeline;
  }

  private async findOne(id: string) {
    const timeline = await this.timelinesRepository.findOne(id);

    if (!timeline) {
      throw new NotFoundException('타임라인이 존재하지 않습니다.');
    }

    return timeline;
  }

  async findCoordinates(place: string, offset: number, limit: number) {
    const url = `${KAKAO_KEYWORD_SEARCH}?query=${place}&page=${offset}&size=${limit}`;
    const {
      data: { documents },
    } = await axios.get(url, {
      headers: { Authorization: `KakaoAK ${process.env.KAKAO_REST_API_KEY}` },
    });

    return documents;
  }
}
