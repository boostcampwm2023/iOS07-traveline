import { LIKEDS_REPOSITORY } from '../postings.constants';
import { Inject, Injectable } from '@nestjs/common';
import { Liked } from '../entities/liked.entity';
import { Repository } from 'typeorm';

@Injectable()
export class LikedsRepository {
  constructor(
    @Inject(LIKEDS_REPOSITORY)
    private likesRepository: Repository<Liked>
  ) {}
}
