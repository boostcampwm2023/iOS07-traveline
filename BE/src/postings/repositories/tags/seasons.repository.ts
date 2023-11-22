import { SEASONS_REPOSITORY } from '../../postings.constants';
import { Season } from '../../entities/tags/season.entity';
import { Inject, Injectable } from '@nestjs/common';
import { TagRepository } from './tag.repository';
import { Repository } from 'typeorm';

@Injectable()
export class SeasonsRepository extends TagRepository<Season> {
  constructor(
    @Inject(SEASONS_REPOSITORY)
    private seasonsRepository: Repository<Season>
  ) {
    super(seasonsRepository);
  }
}
