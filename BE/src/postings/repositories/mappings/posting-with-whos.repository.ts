import { PostingWithWho } from 'src/postings/entities/mappings/posting-with-who.entity';
import { POSTING_WITH_WHOS_REPOSITORY } from '../../postings.constants';
import { PostingMappingRepository } from './posting-mapping.repository';
import { Inject, Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';

@Injectable()
export class PostingWithWhosRepository extends PostingMappingRepository<PostingWithWho> {
  constructor(
    @Inject(POSTING_WITH_WHOS_REPOSITORY)
    private postingWithWhosRepository: Repository<PostingWithWho>
  ) {
    super(postingWithWhosRepository);
  }
}
