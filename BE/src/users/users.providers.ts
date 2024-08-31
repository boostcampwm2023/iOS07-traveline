import { Block } from './entities/block.entity';
import { User } from './entities/user.entity';
import { DataSource } from 'typeorm';
import {
  BLOCK_REPOSITORY,
  DATA_SOURCE,
  USERS_REPOSITORY,
} from './users.constants';

export const usersProvider = [
  {
    provide: USERS_REPOSITORY,
    useFactory: (dataSource: DataSource) => dataSource.getRepository(User),
    inject: [DATA_SOURCE],
  },
  {
    provide: BLOCK_REPOSITORY,
    useFactory: (dataSource: DataSource) => dataSource.getRepository(Block),
    inject: [DATA_SOURCE],
  },
];
