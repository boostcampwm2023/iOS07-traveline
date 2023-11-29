import {
  Injectable,
  ForbiddenException,
  NotFoundException,
} from '@nestjs/common';
import { CreateTimelineDto } from './dto/create-timeline.dto';
import { UpdateTimelineDto } from './dto/update-timeline.dto';
import { TimelinesRepository } from './timelines.repository';
import { Timeline } from './entities/timeline.entity';
import { PostingsService } from '../postings/postings.service';

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

    const timeline = this.initialize(createTimelineDto);
    timeline.posting = posting;

    return this.timelinesRepository.save(timeline);
  }

  findAll() {
    return `This action returns all timelines`;
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
    const updatedTimeline = this.initialize(updateTimelineDto);
    updatedTimeline.id = id;

    return this.timelinesRepository.update(id, updatedTimeline);
  }

  async remove(id: string) {
    const timeline = await this.timelinesRepository.findOne(id);

    return this.timelinesRepository.remove(timeline);
  }

  private initialize(
    timelineDto: CreateTimelineDto | UpdateTimelineDto
  ): Timeline {
    const timeline = new Timeline();
    timeline.title = timelineDto.title;
    timeline.day = timelineDto.day;
    timeline.description = timelineDto.description;
    timeline.image = timelineDto.image;
    timeline.coordX = timelineDto.coordX;
    timeline.coordY = timelineDto.coordY;
    timeline.date = timelineDto.date;
    timeline.place = timelineDto.place;
    timeline.time = timelineDto.time;
    return timeline;
  }
}
