import { DataSource } from 'typeorm';
import { Posting } from './entities/posting.entity';
import {
  BUDGETS_REPOSITORY,
  DATA_SOURCE,
  HEADCOUNTS_REPOSITORY,
  LIKEDS_REPOSITORY,
  LOCATIONS_REPOSITORY,
  PERIODS_REPOSITORY,
  POSTINGS_REPOSITORY,
  POSTING_THEMES_REPOSITORY,
  POSTING_WITH_WHOS_REPOSITORY,
  REPORTS_REPOSITORY,
  SEASONS_REPOSITORY,
  THEMES_REPOSITORY,
  VEHICLES_REPOSITORY,
  WITH_WHOS_REPOSITORY,
} from './postings.constants';
import { Liked } from './entities/liked.entity';
import { Report } from './entities/report.entity';
import { Budget } from './entities/tags/budget.entity';
import { Headcount } from './entities/tags/headcount.entity';
import { Location } from './entities/tags/location.entity';
import { Period } from './entities/tags/period.entity';
import { Season } from './entities/tags/season.entity';
import { Theme } from './entities/tags/theme.entity';
import { Vehicle } from './entities/tags/vehicle.entity';
import { WithWho } from './entities/tags/with-who.entity';
import { PostingTheme } from './entities/mappings/posting-theme.entity';
import { PostingWithWho } from './entities/mappings/posting-with-who.entity';

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
  {
    provide: BUDGETS_REPOSITORY,
    useFactory: (dataSource: DataSource) => dataSource.getRepository(Budget),
    inject: [DATA_SOURCE],
  },
  {
    provide: HEADCOUNTS_REPOSITORY,
    useFactory: (dataSource: DataSource) => dataSource.getRepository(Headcount),
    inject: [DATA_SOURCE],
  },
  {
    provide: LOCATIONS_REPOSITORY,
    useFactory: (dataSource: DataSource) => dataSource.getRepository(Location),
    inject: [DATA_SOURCE],
  },
  {
    provide: PERIODS_REPOSITORY,
    useFactory: (dataSource: DataSource) => dataSource.getRepository(Period),
    inject: [DATA_SOURCE],
  },
  {
    provide: SEASONS_REPOSITORY,
    useFactory: (dataSource: DataSource) => dataSource.getRepository(Season),
    inject: [DATA_SOURCE],
  },
  {
    provide: THEMES_REPOSITORY,
    useFactory: (dataSource: DataSource) => dataSource.getRepository(Theme),
    inject: [DATA_SOURCE],
  },
  {
    provide: VEHICLES_REPOSITORY,
    useFactory: (dataSource: DataSource) => dataSource.getRepository(Vehicle),
    inject: [DATA_SOURCE],
  },
  {
    provide: WITH_WHOS_REPOSITORY,
    useFactory: (dataSource: DataSource) => dataSource.getRepository(WithWho),
    inject: [DATA_SOURCE],
  },
  {
    provide: POSTING_THEMES_REPOSITORY,
    useFactory: (dataSource: DataSource) =>
      dataSource.getRepository(PostingTheme),
    inject: [DATA_SOURCE],
  },
  {
    provide: POSTING_WITH_WHOS_REPOSITORY,
    useFactory: (dataSource: DataSource) =>
      dataSource.getRepository(PostingWithWho),
    inject: [DATA_SOURCE],
  },
];
