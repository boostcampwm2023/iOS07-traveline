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

  findNameByCalculatingStartDate(startDate: Date) {
    const month = startDate.getMonth() + 1;
    return month >= 3 && month <= 5
      ? '봄'
      : month >= 6 && month <= 9
      ? '여름'
      : month >= 10 && month <= 11
      ? '가을'
      : '겨울';
  }
}
