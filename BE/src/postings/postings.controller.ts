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
  DefaultValuePipe,
  ParseUUIDPipe,
} from '@nestjs/common';
import { PostingsService } from './postings.service';
import { CreatePostingDto } from './dto/create-posting.dto';
import { UpdatePostingDto } from './dto/update-posting.dto';
import { SearchPostingDto } from './dto/search-posting.dto';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiConflictResponse,
  ApiCreatedResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiQuery,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { Posting } from './entities/posting.entity';
import { Report } from './entities/report.entity';
import { AuthGuard } from '../auth/auth.guard';
import {
  create_OK,
  findOne_OK,
  like_OK,
  remove_OK,
  report_OK,
  searchByWord_OK,
  search_OK,
  update_OK,
} from './posting.swagger';

@ApiBearerAuth('accessToken')
@UseGuards(AuthGuard)
@Controller('postings')
@ApiTags('Postings API')
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
      message: '게시글이 존재하지 않습니다.',
      error: 'Not Found',
      statusCode: 404,
    },
  },
})
export class PostingsController {
  constructor(private readonly postingsService: PostingsService) {}

  @Post()
  @ApiOperation({
    summary: '게시글 생성',
    description: '사용자가 입력한 정보를 토대로 새로운 게시글을 생성합니다.',
  })
  @ApiCreatedResponse({ schema: { example: create_OK } })
  @ApiBadRequestResponse({
    schema: {
      example: {
        message: 'endDate는 startDate와 같거나 더 나중의 날짜여야 합니다.',
        error: 'Bad Request',
        statusCode: 400,
      },
    },
  })
  async create(
    @Req() request,
    @Body() createPostingDto: CreatePostingDto
  ): Promise<Posting> {
    const userId = request['user'].id;
    return this.postingsService.create(userId, createPostingDto);
  }

  @Get()
  @ApiOperation({
    summary: '게시글 검색 결과',
    description: '검색어와 선택 태그의 교집합에 해당하는 게시글을 반환합니다.',
  })
  @ApiOkResponse({ schema: { example: search_OK } })
  async search(
    @Query() searchPostingDto: SearchPostingDto
  ): Promise<Posting[]> {
    return this.postingsService.findAll(searchPostingDto);
  }

  @Get('/titles')
  @ApiOperation({
    summary: '게시글 제목 목록 반환',
    description:
      '전달된 키워드로 시작하는 제목을 가진 포스팅의 제목을 반환합니다.',
  })
  @ApiQuery({
    name: 'keyword',
    description: "검색어 (default: '')",
    required: false,
  })
  @ApiOkResponse({ schema: { example: searchByWord_OK } })
  async searchByKeyWord(
    @Query('keyword', new DefaultValuePipe('')) keyword: string
  ): Promise<string[]> {
    return this.postingsService.findAllBytitle(keyword);
  }

  @Get(':id')
  @ApiOperation({
    summary: '특정 게시글 반환',
    description: 'id 값에 해당되는 게시글을 반환합니다.',
  })
  @ApiOkResponse({ schema: { example: findOne_OK } })
  async findOne(@Req() request, @Param('id', ParseUUIDPipe) id: string) {
    const userId = request['user'].id;
    const posting = await this.postingsService.findOne(id);

    return {
      ...posting,
      days: this.createDaysList(posting.startDate, posting.days),
      reports: posting.reports.length,
      likeds: posting.likeds.length,
      isLiked: posting.likeds.some((liked) => liked.user === userId),
      isOwner: posting.writer.id === userId,
    };
  }

  @Put(':id')
  @ApiOperation({
    summary: '게시글 수정',
    description: 'id 값에 해당되는 게시글을 수정합니다.',
  })
  @ApiOkResponse({ schema: { example: update_OK } })
  async update(
    @Req() request,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() updatePostingDto: UpdatePostingDto
  ) {
    const userId = request['user'].id;
    return this.postingsService.update(id, userId, updatePostingDto);
  }

  @Delete(':id')
  @ApiOperation({
    summary: '게시글 삭제',
    description: 'id 값에 해당되는 게시글을 삭제합니다.',
  })
  @ApiOkResponse({ schema: { example: remove_OK } })
  async remove(
    @Req() request,
    @Param('id', ParseUUIDPipe) id: string
  ): Promise<Posting> {
    const userId = request['user'].id;
    return this.postingsService.remove(id, userId);
  }

  @Post(':id/like')
  @ApiOperation({
    summary: '게시글 좋아요 토글',
    description: 'id 값에 해당하는 게시글에 좋아요가 추가되거나 삭제됩니다.',
  })
  @ApiOkResponse({ schema: { examples: [update_OK, like_OK] } })
  async toggleLike(@Req() request, @Param('id', ParseUUIDPipe) id: string) {
    const userId = request['user'].id;
    return this.postingsService.toggleLike(id, userId);
  }

  @Post(':id/report')
  @ApiOperation({
    summary: '게시글 신고',
    description: 'id에 해당하는 게시글을 신고합니다.',
  })
  @ApiCreatedResponse({ schema: { example: report_OK } })
  @ApiConflictResponse({
    schema: {
      example: {
        message: '이미 신고한 게시글입니다.',
        error: 'Conflict',
        statusCode: 409,
      },
    },
  })
  async report(
    @Req() request,
    @Param('id', ParseUUIDPipe) id: string
  ): Promise<Report> {
    const userId = request['user'].id;
    return this.postingsService.report(id, userId);
  }

  private createDaysList(startDate: Date, days: number) {
    const weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    const standardDate = new Date(startDate);

    return Array.from({ length: days }, (_, index) => {
      const date = new Date(startDate);
      date.setDate(standardDate.getDate() + index);
      return `${date.getDate()}${weekdays[date.getDay()]}`;
    });
  }
}
