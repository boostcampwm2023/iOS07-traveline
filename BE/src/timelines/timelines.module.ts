import { Module } from '@nestjs/common';
import { TimelinesService } from './timelines.service';
import { TimelinesController } from './timelines.controller';
import { timelinesProviders } from './timelines.providers';
import { DatabaseModule } from '../database/database.module';
import { PostingsModule } from '../postings/postings.module';
import { TimelinesRepository } from './timelines.repository';
import { PostingsService } from '../postings/postings.service';
import { UsersModule } from '../users/users.module';
import { PostingsRepository } from '../postings/repositories/postings.repository';
import { LikedsRepository } from '../postings/repositories/likeds.repository';
import { ReportsRepository } from '../postings/repositories/reports.repository';
import { postingsProviders } from '../postings/postings.providers';
import { StorageModule } from '../storage/storage.module';

@Module({
  imports: [DatabaseModule, PostingsModule, UsersModule, StorageModule],
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
