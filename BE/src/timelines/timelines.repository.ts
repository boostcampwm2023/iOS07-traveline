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

  async save(timeline: Timeline) {
    return this.timelineRepository.save(timeline);
  }

  async findOne(id: string) {
    return this.timelineRepository.findOne({
      where: { id },
      relations: { posting: true },
    });
  }

  async findAll(posting: string, day: number) {
    return this.timelineRepository
      .createQueryBuilder()
      .select([
        'id',
        'title',
        'place',
        'time',
        'image',
        'coord_x AS coordX',
        'coord_y AS coordY',
      ])
      .addSelect('SUBSTRING(description, 1, 40) AS description')
      .where('posting = :posting', { posting })
      .andWhere('day = :day', { day })
      .orderBy('time', 'ASC')
      .getRawMany();
  }

  async findOneWithNonEmptyImage(posting: string) {
    return this.timelineRepository
      .createQueryBuilder()
      .where('posting = :posting', { posting })
      .andWhere('image IS NOT NULL AND image != ""')
      .getOne();
  }

  async update(id: string, timeline: Timeline) {
    return this.timelineRepository.update(id, timeline);
  }

  async remove(timeline: Timeline) {
    return this.timelineRepository.remove(timeline);
  }
}
