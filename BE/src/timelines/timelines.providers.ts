import { DATA_SOURCE, TIMELINES_REPOSITORY } from './timelines.constants';
import { Timeline } from './entities/timeline.entity';
import { DataSource } from 'typeorm';

export const timelinesProviders = [
  {
    provide: TIMELINES_REPOSITORY,
    useFactory: (dataSource: DataSource) => dataSource.getRepository(Timeline),
    inject: [DATA_SOURCE],
  },
];
