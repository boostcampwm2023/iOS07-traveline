import { TIMELINES_REPOSITORY } from './timelines.constants';
import { Timeline } from './entities/timeline.entity';
import { Inject, Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';

@Injectable()
export class TimelinesRepository {
  constructor(
    @Inject(TIMELINES_REPOSITORY)
    private timelineRepository: Repository<Timeline>
  ) {}
}
