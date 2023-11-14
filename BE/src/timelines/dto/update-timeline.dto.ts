import { PartialType } from '@nestjs/swagger';
import { CreateTimelineDto } from './create-timeline.dto';

export class UpdateTimelineDto extends PartialType(CreateTimelineDto) {}
