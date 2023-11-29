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
} from '@nestjs/common';
import { TimelinesService } from './timelines.service';
import { CreateTimelineDto } from './dto/create-timeline.dto';
import { UpdateTimelineDto } from './dto/update-timeline.dto';
import {
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiForbiddenResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { Timeline } from './entities/timeline.entity';
import { AuthGuard } from 'src/auth/auth.guard';
import { create_OK } from './timelines.swagger';

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
  create(
    @Req() request,
    @Body() createTimelineDto: CreateTimelineDto
  ): Promise<Timeline> {
    const userId = request['user'].id;
    return this.timelinesService.create(userId, createTimelineDto);
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
