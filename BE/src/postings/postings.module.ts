import { Module } from '@nestjs/common';
import { PostingsService } from './postings.service';
import { PostingsController } from './postings.controller';
import { DatabaseModule } from 'src/database/database.module';
import { postingsProviders } from './postings.providers';

@Module({
  imports: [DatabaseModule],
  controllers: [PostingsController],
  providers: [...postingsProviders, PostingsService],
})
export class PostingsModule {}
