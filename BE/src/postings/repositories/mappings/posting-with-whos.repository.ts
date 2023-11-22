import { PostingWithWho } from 'src/postings/entities/mappings/posting-with-who.entity';
import { POSTING_WITH_WHOS_REPOSITORY } from '../../postings.constants';
import { Inject, Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';

@Injectable()
export class PostingWithWhosRepository {
  constructor(
    @Inject(POSTING_WITH_WHOS_REPOSITORY)
    private postingWithWhosRepository: Repository<PostingWithWho>
  ) {}
}
