import { Module } from '@nestjs/common';
import { TimelinesService } from './timelines.service';
import { TimelinesController } from './timelines.controller';
import { timelinesProviders } from './timelines.providers';
import { DatabaseModule } from '../database/database.module';
import { PostingsModule } from '../postings/postings.module';
import { TimelinesRepository } from './timelines.repository';
import { PostingsService } from '../postings/postings.service';
import { UsersModule } from 'src/users/users.module';
import { PostingsRepository } from 'src/postings/repositories/postings.repository';
import { LikedsRepository } from 'src/postings/repositories/likeds.repository';
import { ReportsRepository } from 'src/postings/repositories/reports.repository';
import { postingsProviders } from 'src/postings/postings.providers';

@Module({
  imports: [DatabaseModule, PostingsModule, UsersModule],
  controllers: [TimelinesController],
  providers: [
    ...timelinesProviders,
    ...postingsProviders,
    TimelinesService,
    PostingsService,
    TimelinesRepository,
    PostingsRepository,
    LikedsRepository,
    ReportsRepository,
  ],
})
export class TimelinesModule {}
