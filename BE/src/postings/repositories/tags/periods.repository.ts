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
}
