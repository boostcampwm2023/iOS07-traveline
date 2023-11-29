import { Module } from '@nestjs/common';
import { TimelinesService } from './timelines.service';
import { TimelinesController } from './timelines.controller';
import { timelinesProviders } from './timelines.providers';
import { DatabaseModule } from 'src/database/database.module';
import { TimelinesRepository } from './timelines.repository';

@Module({
  imports: [DatabaseModule],
  controllers: [TimelinesController],
  providers: [...timelinesProviders, TimelinesService, TimelinesRepository],
})
export class TimelinesModule {}
