import { DataSource } from 'typeorm';
import { Posting } from './entities/posting.entity';
import {
  DATA_SOURCE,
  LIKED_REPOSITORY,
  POSTINGS_REPOSITORY,
} from './postings.constants';
import { Liked } from './entities/liked.entity';

export const postingsProviders = [
  {
    provide: POSTINGS_REPOSITORY,
    useFactory: (dataSource: DataSource) => dataSource.getRepository(Posting),
    inject: [DATA_SOURCE],
  },
  {
    provide: LIKED_REPOSITORY,
    useFactory: (dataSource: DataSource) => dataSource.getRepository(Liked),
    inject: [DATA_SOURCE],
  },
];
