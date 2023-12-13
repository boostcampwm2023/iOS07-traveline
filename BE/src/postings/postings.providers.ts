import { DataSource } from 'typeorm';
import { Posting } from './entities/posting.entity';
import {
  DATA_SOURCE,
  LIKEDS_REPOSITORY,
  POSTINGS_REPOSITORY,
  REPORTS_REPOSITORY,
} from './postings.constants';
import { Liked } from './entities/liked.entity';
import { Report } from './entities/report.entity';

export const postingsProviders = [
  {
    provide: POSTINGS_REPOSITORY,
    useFactory: (dataSource: DataSource) => dataSource.getRepository(Posting),
    inject: [DATA_SOURCE],
  },
  {
    provide: LIKEDS_REPOSITORY,
    useFactory: (dataSource: DataSource) => dataSource.getRepository(Liked),
    inject: [DATA_SOURCE],
  },
  {
    provide: REPORTS_REPOSITORY,
    useFactory: (dataSource: DataSource) => dataSource.getRepository(Report),
    inject: [DATA_SOURCE],
  },
];
