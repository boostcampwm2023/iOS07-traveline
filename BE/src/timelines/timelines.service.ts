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
import { PostingsService } from '../postings/postings.service';
import { KAKAO_KEYWORD_SEARCH } from './timelines.constants';

@Injectable()
export class TimelinesService {
  constructor(
    private readonly timelinesRepository: TimelinesRepository,
    private readonly postingsService: PostingsService
  ) {}

  async create(userId: string, createTimelineDto: CreateTimelineDto) {
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

    return this.timelinesRepository.save(timeline);
  }

  async findAll(postingId: string, day: number) {
    const timelines = await this.timelinesRepository.findAll(postingId, day);

    return timelines.map((timeline) => {
      return { ...timeline, description: timeline.description + '...' };
    });
  }

  async findOne(id: string) {
    const timeline = await this.timelinesRepository.findOne(id);

    if (!timeline) {
      throw new NotFoundException('타임라인이 존재하지 않습니다.');
    }

    return timeline;
  }

  async update(id: string, updateTimelineDto: UpdateTimelineDto) {
    await this.findOne(id);
    const updatedTimeline = await this.initialize(updateTimelineDto);
    updatedTimeline.id = id;

    return this.timelinesRepository.update(id, updatedTimeline);
  }

  async remove(id: string) {
    const timeline = await this.findOne(id);

    return this.timelinesRepository.remove(timeline);
  }

  private async initialize(
    timelineDto: CreateTimelineDto | UpdateTimelineDto
  ): Promise<Timeline> {
    const timeline = new Timeline();
    const coordinates = await this.findCoordinates(timelineDto.place);
    Object.assign(timeline, timelineDto);
    Object.assign(timeline, coordinates);
    // timeline.image = timelineDto.image;
    return timeline;
  }

  private async findCoordinates(place: string) {
    const url = `${KAKAO_KEYWORD_SEARCH}?query=${place}&size=1`;
    const {
      data: { documents },
    } = await axios.get(url, {
      headers: { Authorization: `KakaoAK ${process.env.KAKAO_REST_API_KEY}` },
    });

    return documents.length < 1
      ? {}
      : { coordX: documents[0].x, coordY: documents[0].y };
  }
}
