import { Module } from '@nestjs/common';
import { PostingsService } from './postings.service';
import { PostingsController } from './postings.controller';

@Module({
  controllers: [PostingsController],
  providers: [PostingsService],
})
export class PostingsModule {}
