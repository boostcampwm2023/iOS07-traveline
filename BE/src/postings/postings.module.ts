import { Module } from '@nestjs/common';
import { PostingsService } from './postings.service';
import { PostingsController } from './postings.controller';
import { DatabaseModule } from '../database/database.module';
import { postingsProviders } from './postings.providers';
import { PostingsRepository } from './repositories/postings.repository';
import { LikedsRepository } from './repositories/likeds.repository';
import { ReportsRepository } from './repositories/reports.repository';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [DatabaseModule, UsersModule],
  controllers: [PostingsController],
  providers: [
    ...postingsProviders,
    PostingsService,
    PostingsRepository,
    LikedsRepository,
    ReportsRepository,
  ],
})
export class PostingsModule {}
