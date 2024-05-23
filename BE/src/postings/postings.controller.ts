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
  ApiForbiddenResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiQuery,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { Report } from './entities/report.entity';
import { AuthGuard } from '../auth/auth.guard';
import {
  create_update_remove_OK,
  findMyPosting_OK,
  findOne_OK,
  like_OK,
  report_OK,
  searchByWord_OK,
  search_OK,
} from './postings.swagger';

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
  @ApiCreatedResponse({ schema: { example: create_update_remove_OK } })
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
  ): Promise<{ id: string }> {
    const userId = request['user'].id;
    const { id } = await this.postingsService.create(userId, createPostingDto);
    return { id };
  }

  @Get()
  @ApiOperation({
    summary: '게시글 검색 결과',
    description: '검색어와 선택 태그의 교집합에 해당하는 게시글을 반환합니다.',
  })
  @ApiOkResponse({ schema: { example: search_OK } })
  async search(@Req() request, @Query() searchPostingDto: SearchPostingDto) {
    const userId = request['user'].id;
    return this.postingsService.findAll(userId, searchPostingDto);
  }

  @Get('titles')
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
  ) {
    return this.postingsService.findAllBytitle(keyword);
  }

  @Get('mine')
  @ApiOperation({
    summary: '내가 작성한 목록 반환',
    description: '현재 로그인한 사용자가 작성한 모든 게시글을 반환합니다.',
  })
  @ApiOkResponse({ schema: { example: findMyPosting_OK } })
  async findMyPosting(@Req() request) {
    const userId = request['user'].id;
    return this.postingsService.findAllByWriter(userId);
  }

  @Get(':id')
  @ApiOperation({
    summary: '특정 게시글 반환',
    description: 'id 값에 해당되는 게시글을 반환합니다.',
  })
  @ApiOkResponse({ schema: { example: findOne_OK } })
  @ApiForbiddenResponse({
    schema: {
      example: {
        message: '차단된 게시글입니다.',
        error: 'Forbidden',
        statusCode: 403,
      },
    },
  })
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
  @ApiOkResponse({ schema: { example: create_update_remove_OK } })
  @ApiForbiddenResponse({
    schema: {
      example: {
        message: '본인이 작성한 게시글만 수정할 수 있습니다.',
        error: 'Forbidden',
        statusCode: 403,
      },
    },
  })
  async update(
    @Req() request,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() updatePostingDto: UpdatePostingDto
  ): Promise<{ id: string }> {
    const userId = request['user'].id;
    await this.postingsService.update(id, userId, updatePostingDto);
    return { id };
  }

  @Delete(':id')
  @ApiOperation({
    summary: '게시글 삭제',
    description: 'id 값에 해당되는 게시글을 삭제합니다.',
  })
  @ApiOkResponse({ schema: { example: create_update_remove_OK } })
  @ApiForbiddenResponse({
    schema: {
      example: {
        message: '본인이 작성한 게시글만 삭제할 수 있습니다.',
        error: 'Forbidden',
        statusCode: 403,
      },
    },
  })
  async remove(
    @Req() request,
    @Param('id', ParseUUIDPipe) id: string
  ): Promise<{ id: string }> {
    const userId = request['user'].id;
    await this.postingsService.remove(id, userId);
    return { id };
  }

  @Post(':id/like')
  @ApiOperation({
    summary: '게시글 좋아요 토글',
    description: 'id 값에 해당하는 게시글에 좋아요가 추가되거나 삭제됩니다.',
  })
  @ApiOkResponse({ schema: { example: like_OK } })
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
      const stringDate = date.getDate().toString();
      return `${stringDate.length < 2 ? `0${stringDate}` : stringDate} ${
        weekdays[date.getDay()]
      }`;
    });
  }
}
