import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Delete,
  Query,
  Put,
  BadRequestException,
} from '@nestjs/common';
import { PostingsService } from './postings.service';
import { CreatePostingDto } from './dto/create-posting.dto';
import { UpdatePostingDto } from './dto/update-posting.dto';
import { SearchPostingDto } from './dto/search-posting.dto';
import {
  ApiCreatedResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { Posting } from './entities/posting.entity';
import {
  budgets,
  headcounts,
  locations,
  periods,
  seasons,
  themes,
  vehicles,
  withWhos,
} from './postings.types';

@Controller('postings')
@ApiTags('Postings API')
export class PostingsController {
  constructor(private readonly postingsService: PostingsService) {}

  @Post()
  @ApiOperation({
    summary: '포스팅 생성 API',
    description: '새로운 포스팅을 작성한다.',
  })
  @ApiOkResponse({ description: 'OK', type: Posting })
  async create(@Body() createPostingDto: CreatePostingDto) {
    if (
      new Date(createPostingDto.endDate) < new Date(createPostingDto.startDate)
    ) {
      throw new BadRequestException(
        'endDate는 startDate와 같거나 더 나중의 날짜여야 합니다.'
      );
    }

    return this.postingsService.create(createPostingDto);
  }

  @Get()
  @ApiOperation({
    summary: '포스팅 검색 결과 API',
    description: '전달된 쿼리 값에 따른 검색 결과를 반환한다.',
  })
  @ApiOkResponse({ description: 'OK', type: [Posting] })
  search(@Query() searchPostingDto: SearchPostingDto) {
    //return this.postingsService.search(searchPostingDto);
  }

  @Get(':id')
  @ApiOperation({
    summary: '포스팅 로드 API',
    description: 'id 값에 해당되는 포스팅을 반환한다.',
  })
  @ApiOkResponse({ description: 'OK', type: Posting })
  async findOne(@Param('id') id: string) {
    const posting = await this.postingsService.findOne(id);
    return {
      id: posting.id,
      writer: posting.writer,
      title: posting.title,
      createdAt: posting.created_at,
      thumbnail: posting.thumbnail,
      startDate: posting.start_date,
      endDate: posting.end_date,
      days: posting.days,
      period: periods[posting.period] || null,
      headcount: headcounts[posting.headcount] || null,
      budget: budgets[posting.budget] || null,
      location: locations[posting.location],
      season: seasons[posting.season],
      vehicle: vehicles[posting.vehicle] || null,
      theme: posting.theme ? posting.theme.map((e) => themes[e]) : null,
      withWho: posting.with_who
        ? posting.with_who.map((e) => withWhos[e])
        : null,
      report: posting.report,
      liked: posting.liked,
      isOwner: false, // TODO: JWT에 있는 사용자와 writer가 동일한지 확인하기
    };
  }

  @Put(':id')
  @ApiOperation({
    summary: '포스팅 수정 API',
    description: 'id 값에 해당되는 포스팅을 수정한다.',
  })
  @ApiOkResponse({ description: 'OK' })
  update(@Param('id') id: string, @Body() updatePostingDto: UpdatePostingDto) {
    return this.postingsService.update(id, updatePostingDto);
  }

  @Delete(':id')
  @ApiOperation({
    summary: '포스팅 삭제 API',
    description: 'id 값에 해당되는 포스팅을 삭제한다.',
  })
  @ApiOkResponse({ description: 'OK' })
  remove(@Param('id') id: string) {
    return this.postingsService.remove(id);
  }

  @Get('/titles')
  @ApiOperation({
    summary: '포스팅 제목 검색 API',
    description:
      '전달된 키워드로 시작하는 제목을 가진 포스팅의 제목을 반환한다.',
  })
  @ApiOkResponse({ description: 'OK', type: [String] })
  searchByKeyWord(@Query('keyword') keyword: string) {
    //return this.postingsService.searchByKeyWord(keyword);
  }

  @Post(':id/like')
  @ApiOperation({
    summary: '포스팅 좋아요 API',
    description: 'id 값에 해당되는 포스팅에 좋아요를 추가한다.',
  })
  @ApiOkResponse({ description: 'OK' })
  addLike(@Param('id') id: string) {
    //return this.postingsService.addLike(+id);
  }

  @Delete(':id/like')
  @ApiOperation({
    summary: '포스팅 좋아요 취소 API',
    description: 'id 값에 해당되는 포스팅의 좋아요를 취소한다.',
  })
  @ApiOkResponse({ description: 'OK' })
  removeLike(@Param('id') id: string) {
    //return this.postingsService.removeLike(+id);
  }

  @Post(':id/report')
  @ApiOperation({
    summary: '게시글 신고',
    description: 'id에 해당하는 게시글을 신고한다.',
  })
  @ApiCreatedResponse({
    description: 'OK',
  })
  report(@Param('id') id: string) {
    //return this.postingsService.report(+id);
  }
}
