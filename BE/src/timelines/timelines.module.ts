import { Module } from '@nestjs/common';
import { TimelinesService } from './timelines.service';
import { TimelinesController } from './timelines.controller';

@Module({
  controllers: [TimelinesController],
  providers: [TimelinesService],
})
export class TimelinesModule {}
