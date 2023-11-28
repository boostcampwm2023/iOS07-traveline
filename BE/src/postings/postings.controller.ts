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
} from '@nestjs/common';
import { PostingsService } from './postings.service';
import { CreatePostingDto } from './dto/create-posting.dto';
import { UpdatePostingDto } from './dto/update-posting.dto';
import { SearchPostingDto } from './dto/search-posting.dto';
import {
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { Posting } from './entities/posting.entity';
import { AuthGuard } from '../auth/auth.guard';

// TODO: response dto 생성
@UseGuards(AuthGuard)
@Controller('postings')
@ApiTags('Postings API')
export class PostingsController {
  constructor(private readonly postingsService: PostingsService) {}

  @Post()
  @ApiBearerAuth()
  @ApiOperation({
    summary: '포스팅 생성 API',
    description: '새로운 포스팅을 작성한다.',
  })
  @ApiCreatedResponse({ description: 'Created', type: Posting })
  async create(
    @Req() request,
    @Body() createPostingDto: CreatePostingDto
  ): Promise<Posting> {
    const userId = request['user'].id;
    return this.postingsService.create(userId, createPostingDto);
  }

  @Get()
  @ApiOperation({
    summary: '포스팅 검색 결과 API',
    description: '전달된 쿼리 값에 따른 검색 결과를 반환한다.',
  })
  @ApiOkResponse({ description: 'OK', type: [Posting] })
  async search(
    @Query() searchPostingDto: SearchPostingDto
  ): Promise<Posting[]> {
    return this.postingsService.findAll(searchPostingDto);
  }

  @Get('/titles')
  @ApiOperation({
    summary: '포스팅 제목 검색 API',
    description:
      '전달된 키워드로 시작하는 제목을 가진 포스팅의 제목을 반환한다.',
  })
  @ApiOkResponse({ description: 'OK', type: [String] })
  searchByKeyWord(@Query('keyword', new DefaultValuePipe('')) keyword: string) {
    return this.postingsService.findAllBytitle(keyword);
  }

  @Get(':id')
  @ApiBearerAuth()
  @ApiOperation({
    summary: '포스팅 로드 API',
    description: 'id 값에 해당되는 포스팅을 반환한다.',
  })
  async findOne(@Req() request, @Param('id') id: string) {
    const userId = request['user'].id;
    const posting = await this.postingsService.findOne(id);

    return {
      ...posting,
      days: this.createDaysList(posting.startDate, posting.days),
      liked: posting.liked.length,
      report: posting.report.length,
      isLiked: posting.liked.some((liked) => liked.user === userId),
      isOwner: posting.writer.id === userId,
    };
  }

  @Put(':id')
  @ApiBearerAuth()
  @ApiOperation({
    summary: '포스팅 수정 API',
    description: 'id 값에 해당되는 포스팅을 수정한다.',
  })
  @ApiOkResponse({ description: 'OK' })
  update(
    @Req() request,
    @Param('id') id: string,
    @Body() updatePostingDto: UpdatePostingDto
  ) {
    const userId = request['user'].id;
    return this.postingsService.update(id, userId, updatePostingDto);
  }

  @Delete(':id')
  @ApiBearerAuth()
  @ApiOperation({
    summary: '포스팅 삭제 API',
    description: 'id 값에 해당되는 포스팅을 삭제한다.',
  })
  @ApiOkResponse({ description: 'OK' })
  remove(@Req() request, @Param('id') id: string) {
    const userId = request['user'].id;
    return this.postingsService.remove(id, userId);
  }

  @Post(':id/like')
  @ApiBearerAuth()
  @ApiOperation({
    summary: '포스팅 좋아요 API',
    description:
      'id 값에 해당되는 포스팅에 좋아요가 추가되거나 삭제된다. (토글)',
  })
  @ApiOkResponse({ description: 'OK' })
  toggleLike(@Req() request, @Param('id') id: string) {
    const userId = request['user'].id;
    return this.postingsService.toggleLike(id, userId);
  }

  @Post(':id/report')
  @ApiBearerAuth()
  @ApiOperation({
    summary: '게시글 신고',
    description: 'id에 해당하는 게시글을 신고한다.',
  })
  @ApiCreatedResponse({
    description: 'OK',
  })
  report(@Req() request, @Param('id') id: string) {
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
