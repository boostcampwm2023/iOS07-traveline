import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Delete,
  Query,
  Put,
  UseGuards,
} from '@nestjs/common';
import { TimelinesService } from './timelines.service';
import { CreateTimelineDto } from './dto/create-timeline.dto';
import { UpdateTimelineDto } from './dto/update-timeline.dto';
import {
  ApiCreatedResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { Timeline } from './entities/timeline.entity';
import { AuthGuard } from 'src/auth/auth.guard';

@UseGuards(AuthGuard)
@Controller('timelines')
@ApiTags('Timelines API')
export class TimelinesController {
  constructor(private readonly timelinesService: TimelinesService) {}

  @Post()
  @ApiOperation({
    summary: 'Timeline 정보 저장',
    description: 'Timeline 정보를 저장한다.',
  })
  @ApiCreatedResponse({
    description: 'Created',
    type: CreateTimelineDto,
  })
  create(@Body() createTimelineDto: CreateTimelineDto) {
    return this.timelinesService.create(createTimelineDto);
  }

  @Get()
  @ApiOperation({
    summary: 'postingId에 해당하는 게시글의 모든 Timeline 반환',
    description: 'postingId에 해당하는 게시글의 모든 Timeline을 반환한다.',
  })
  @ApiOkResponse({
    description: 'OK',
    type: [Timeline],
  })
  findAll(@Query('postingId') postingId: string) {
    return this.timelinesService.findAll();
  }

  @Get(':id')
  @ApiOperation({
    summary: 'id에 해당하는 상세 Timeline 반환',
    description: 'id에 해당하는 상세 Timeline을 반환한다.',
  })
  @ApiOkResponse({
    description: 'OK',
    type: Timeline,
  })
  findOne(@Param('id') id: string) {
    return this.timelinesService.findOne(+id);
  }

  @Put(':id')
  @ApiOperation({
    summary: 'id에 해당하는 상세 Timeline 수정',
    description: 'id에 해당하는 상세 Timeline을 수정한다.',
  })
  @ApiOkResponse({
    description: 'OK',
  })
  update(
    @Param('id') id: string,
    @Body() updateTimelineDto: UpdateTimelineDto
  ) {
    return this.timelinesService.update(+id, updateTimelineDto);
  }

  @Delete(':id')
  @ApiOperation({
    summary: 'id에 해당하는 상세 Timeline 삭제',
    description: 'id에 해당하는 상세 Timeline을 삭제한다.',
  })
  @ApiOkResponse({
    description: 'OK',
  })
  remove(@Param('id') id: string) {
    return this.timelinesService.remove(+id);
  }
}
