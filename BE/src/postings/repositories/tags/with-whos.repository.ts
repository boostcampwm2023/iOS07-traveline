import { WITH_WHOS_REPOSITORY } from '../../postings.constants';
import { WithWho } from '../../entities/tags/with-who.entity';
import { Inject, Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { TagRepository } from './tag.repository';

@Injectable()
export class WithWhosRepository extends TagRepository<WithWho> {
  constructor(
    @Inject(WITH_WHOS_REPOSITORY)
    private withWhosRepository: Repository<WithWho>
  ) {
    super(withWhosRepository);
  }
}
