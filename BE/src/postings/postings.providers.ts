import { DataSource } from 'typeorm';
import { Posting } from './entities/posting.entity';
import { DATA_SOURCE, POSTINGS_REPOSITORY } from './postings.constants';

export const postingsProviders = [
  {
    provide: POSTINGS_REPOSITORY,
    useFactory: (dataSource: DataSource) => dataSource.getRepository(Posting),
    inject: [DATA_SOURCE],
  },
];
