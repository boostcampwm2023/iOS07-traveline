import { PERIODS_REPOSITORY } from '../../postings.constants';
import { Period } from '../../entities/tags/period.entity';
import { Inject, Injectable } from '@nestjs/common';
import { TagRepository } from './tag.repository';
import { Repository } from 'typeorm';

@Injectable()
export class PeriodsRepository extends TagRepository<Period> {
  constructor(
    @Inject(PERIODS_REPOSITORY)
    private periodsRepository: Repository<Period>
  ) {
    super(periodsRepository);
  }

  findNameByCalculatingDays(days: number) {
    return days === 1
      ? '당일치기'
      : days === 2
      ? '1박 2일'
      : days === 3
      ? '2박 3일'
      : days < 7
      ? '3박 ~'
      : days < 30
      ? '일주일 ~'
      : '한 달 ~';
  }
}
