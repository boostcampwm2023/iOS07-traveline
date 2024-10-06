import { Module } from '@nestjs/common';
import { PostingsService } from './postings.service';
import { PostingsController } from './postings.controller';
import { DatabaseModule } from '../database/database.module';
import { postingsProviders } from './postings.providers';
import { PostingsRepository } from './repositories/postings.repository';
import { LikedsRepository } from './repositories/likeds.repository';
import { ReportsRepository } from './repositories/reports.repository';
import { UsersModule } from '../users/users.module';
import { StorageModule } from 'src/storage/storage.module';

@Module({
  imports: [DatabaseModule, UsersModule, StorageModule],
  controllers: [PostingsController],
  providers: [
    ...postingsProviders,
    PostingsService,
    PostingsRepository,
    LikedsRepository,
    ReportsRepository,
  ],
  exports: [PostingsModule],
})
export class PostingsModule {}
