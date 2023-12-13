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

  findOne(postingId: string, userId: string) {
    return this.likesRepository.findOne({
      where: { posting: postingId, user: userId },
    });
  }

  save(liked: Liked) {
    return this.likesRepository.save(liked);
  }

  toggle(postingId: string, userId: string, isDeleted: boolean) {
    return this.likesRepository.update(
      { posting: postingId, user: userId },
      { isDeleted: !isDeleted }
    );
  }
}
