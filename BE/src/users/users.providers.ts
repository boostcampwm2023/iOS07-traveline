import { User } from './entities/user.entity';
import { DataSource } from 'typeorm';
import { DATA_SOURCE, USERS_REPOSITORY } from './users.constants';

export const usersProvider = [
  {
    provide: USERS_REPOSITORY,
    useFactory: (dataSource: DataSource) => dataSource.getRepository(User),
    inject: [DATA_SOURCE],
  },
];
