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
  UseInterceptors,
  UploadedFile,
} from '@nestjs/common';
import { TimelinesService } from './timelines.service';
import { FileInterceptor } from '@nestjs/platform-express';
import { CreateTimelineDto } from './dto/create-timeline.dto';
import { UpdateTimelineDto } from './dto/update-timeline.dto';
import {
  ApiBearerAuth,
  ApiConsumes,
  ApiCreatedResponse,
  ApiForbiddenResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiQuery,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { Timeline } from './entities/timeline.entity';
import { AuthGuard } from 'src/auth/auth.guard';
import {
  create_OK,
  findAll_OK,
  findCoordinates_OK,
  findOne_OK,
  remove_OK,
  translate_OK,
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
  @UseInterceptors(FileInterceptor('image'))
  @ApiOperation({
    summary: '타임라인 생성',
    description: '사용자가 입력한 정보를 토대로 새로운 타임라인을 생성합니다.',
  })
  @ApiConsumes('multipart/form-data')
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
    @UploadedFile() image: Express.Multer.File,
    @Body() createTimelineDto: CreateTimelineDto
  ) {
    const userId = request['user'].id;
    const { id } = await this.timelinesService.create(
      userId,
      image,
      createTimelineDto
    );

    return { id };
  }

  @Get()
  @ApiOperation({
    summary: '게시글의 Day N에 해당하는 모든 타임라인 반환',
    description:
      'postingId에 해당하는 게시글의 Day N에 해당하는 모든 타임라인을 반환합니다.',
  })
  @ApiQuery({
    name: 'day',
    description: 'Day N의 N (default: 1)',
    required: false,
  })
  @ApiOkResponse({ schema: { example: findAll_OK } })
  async findAll(
    @Query('postingId', ParseUUIDPipe) postingId: string,
    @Query('day', new DefaultValuePipe(1), ParseIntPipe) day: number
  ): Promise<Timeline[]> {
    return this.timelinesService.findAll(postingId, day);
  }

  @Get('map')
  @ApiOperation({
    summary: '장소에 대한 지도 검색 결과 반환',
    description:
      '타임라인에 장소를 입력하면 서버에서 카카오 지도 API로 검색한 결과를 반환합니다.',
  })
  @ApiQuery({ name: 'place', description: '검색할 장소', required: true })
  @ApiQuery({
    name: 'offset',
    description: 'offset번째 페이지 (default: 1)',
    required: false,
  })
  @ApiQuery({
    name: 'limit',
    description: 'limit 개의 검색 결과 반환 (default: 15)',
    required: false,
  })
  @ApiOkResponse({ schema: { example: findCoordinates_OK } })
  async findCoordinates(
    @Query('place') place: string,
    @Query('offset', new DefaultValuePipe(1), ParseIntPipe) offset: number,
    @Query('limit', new DefaultValuePipe(15), ParseIntPipe) limit: number
  ) {
    return this.timelinesService.findCoordinates(place, offset, limit);
  }

  @Get(':id')
  @ApiOperation({
    summary: '특정 타임라인 반환',
    description: 'id에 해당하는 타임라인을 반환합니다.',
  })
  @ApiOkResponse({ schema: { example: findOne_OK } })
  async findOne(@Param('id', ParseUUIDPipe) id: string): Promise<Timeline> {
    return this.timelinesService.findOneWithURL(id);
  }

  @Put(':id')
  @UseInterceptors(FileInterceptor('image'))
  @ApiOperation({
    summary: 'id에 해당하는 타임라인 수정',
    description: 'id에 해당하는 타임라인을 수정합니다.',
  })
  @ApiConsumes('multipart/form-data')
  @ApiOkResponse({ schema: { example: update_OK } })
  async update(
    @Req() request,
    @Param('id', ParseUUIDPipe) id: string,
    @UploadedFile() image: Express.Multer.File,
    @Body() updateTimelineDto: UpdateTimelineDto
  ) {
    const userId = request['user'].id;
    await this.timelinesService.update(id, userId, image, updateTimelineDto);
    return { id };
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

  @Get(':id/translate')
  @ApiOperation({
    summary: 'Papago API 번역',
    description:
      'Papago API를 사용하여 타임라인 세부 내용을 영어로 번역하고, 그 결과를 반환합니다.',
  })
  @ApiOkResponse({ schema: { example: translate_OK } })
  async translate(@Param('id', ParseUUIDPipe) id: string) {
    return this.timelinesService.translate(id);
  }
}
