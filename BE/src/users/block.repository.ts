import { Inject, Injectable } from '@nestjs/common';
import { Block } from './entities/block.entity';
import { BLOCK_REPOSITORY } from './users.constants';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';

@Injectable()
export class BlockRepository {
  constructor(
    @Inject(BLOCK_REPOSITORY)
    private blockRepository: Repository<Block>
  ) {}

  save(blocker: User, blocked: User) {
    return this.blockRepository.save({ blocker, blocked });
  }

  findByBlocker(blocker: string, blocked: string) {
    return this.blockRepository
      .createQueryBuilder('b')
      .leftJoinAndSelect('b.blocker', 'x')
      .leftJoinAndSelect('b.blocked', 'y')
      .where('b.blocker = :blocker AND b.blocked = :blocked', {
        blocker,
        blocked,
      })
      .getOne();
  }
}
