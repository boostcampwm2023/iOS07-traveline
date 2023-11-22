import { HEADCOUNTS_REPOSITORY } from '../../postings.constants';
import { Headcount } from '../../entities/tags/headcount.entity';
import { Inject, Injectable } from '@nestjs/common';
import { TagRepository } from './tag.repository';
import { Repository } from 'typeorm';

@Injectable()
export class HeadcountsRepository extends TagRepository<Headcount> {
  constructor(
    @Inject(HEADCOUNTS_REPOSITORY)
    private headcountsRepository: Repository<Headcount>
  ) {
    super(headcountsRepository);
  }
}
