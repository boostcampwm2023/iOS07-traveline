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
  Req,
  ParseUUIDPipe,
  ParseIntPipe,
  DefaultValuePipe,
} from '@nestjs/common';
import { TimelinesService } from './timelines.service';
import { CreateTimelineDto } from './dto/create-timeline.dto';
import { UpdateTimelineDto } from './dto/update-timeline.dto';
import {
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiForbiddenResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { Timeline } from './entities/timeline.entity';
import { AuthGuard } from 'src/auth/auth.guard';
import {
  create_OK,
  findAll_OK,
  findOne_OK,
  remove_OK,
  update_OK,
} from './timelines.swagger';

@ApiBearerAuth('accessToken')
@UseGuards(AuthGuard)
@Controller('timelines')
@ApiTags('Timelines API')
@ApiUnauthorizedResponse({
  schema: {
    example: {
      message: '로그인이 필요한 서비스 입니다.',
      error: 'Unauthorized',
      statusCode: 401,
    },
  },
})
@ApiNotFoundResponse({
  schema: {
    example: {
      message: '타임라인이 존재하지 않습니다.',
      error: 'Not Found',
      statusCode: 404,
    },
  },
})
export class TimelinesController {
  constructor(private readonly timelinesService: TimelinesService) {}

  @Post()
  @ApiOperation({
    summary: '타임라인 생성',
    description: '사용자가 입력한 정보를 토대로 새로운 타임라인을 생성합니다.',
  })
  @ApiCreatedResponse({ schema: { example: create_OK } })
  @ApiForbiddenResponse({
    schema: {
      example: {
        message:
          '본인이 작성한 게시글에 대해서만 타임라인을 생성할 수 있습니다.',
        error: 'Forbidden',
        statusCode: 403,
      },
    },
  })
  async create(
    @Req() request,
    @Body() createTimelineDto: CreateTimelineDto
  ): Promise<Timeline> {
    const userId = request['user'].id;
    return this.timelinesService.create(userId, createTimelineDto);
  }

  @Get()
  @ApiOperation({
    summary: '게시글의 Day N에 해당하는 모든 타임라인 반환',
    description:
      'postingId에 해당하는 게시글의 Day N에 해당하는 모든 타임라인을 반환합니다.',
  })
  @ApiOkResponse({ schema: { example: findAll_OK } })
  async findAll(
    @Query('postingId', ParseUUIDPipe) postingId: string,
    @Query('day', new DefaultValuePipe(1), ParseIntPipe) day: number
  ): Promise<Timeline[]> {
    return this.timelinesService.findAll(postingId, day);
  }

  @Get(':id')
  @ApiOperation({
    summary: '특정 타임라인 반환',
    description: 'id에 해당하는 타임라인을 반환합니다.',
  })
  @ApiOkResponse({ schema: { example: findOne_OK } })
  async findOne(@Param('id', ParseUUIDPipe) id: string): Promise<Timeline> {
    return this.timelinesService.findOne(id);
  }

  @Put(':id')
  @ApiOperation({
    summary: 'id에 해당하는 타임라인 수정',
    description: 'id에 해당하는 타임라인을 수정합니다.',
  })
  @ApiOkResponse({ schema: { example: update_OK } })
  async update(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() updateTimelineDto: UpdateTimelineDto
  ) {
    return this.timelinesService.update(id, updateTimelineDto);
  }

  @Delete(':id')
  @ApiOperation({
    summary: 'id에 해당하는 타임라인 삭제',
    description: 'id에 해당하는 상세 타임라인을 삭제합니다.',
  })
  @ApiOkResponse({ schema: { example: remove_OK } })
  async remove(@Param('id', ParseUUIDPipe) id: string): Promise<Timeline> {
    return this.timelinesService.remove(id);
  }
}
