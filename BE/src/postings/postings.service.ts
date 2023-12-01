import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { CreatePostingDto } from './dto/create-posting.dto';
import { UpdatePostingDto } from './dto/update-posting.dto';
import { SearchPostingDto } from './dto/search-posting.dto';
import { Posting } from './entities/posting.entity';
import { LikedsRepository } from './repositories/likeds.repository';
import { PostingsRepository } from './repositories/postings.repository';
import { ReportsRepository } from './repositories/reports.repository';
import { UserRepository } from 'src/users/users.repository';
import { Liked } from './entities/liked.entity';
import { Report } from './entities/report.entity';
import { Period, Season } from './postings.types';
import { BLOCKING_LIMIT } from './postings.constants';

@Injectable()
export class PostingsService {
  constructor(
    private readonly userRepository: UserRepository,
    private readonly postingsRepository: PostingsRepository,
    private readonly likedsRepository: LikedsRepository,
    private readonly reportsRepository: ReportsRepository
  ) {}

  async create(userId: string, createPostingDto: CreatePostingDto) {
    if (
      new Date(createPostingDto.endDate) < new Date(createPostingDto.startDate)
    ) {
      throw new BadRequestException(
        'endDate는 startDate와 같거나 더 나중의 날짜여야 합니다.'
      );
    }

    const posting = await this.initialize(createPostingDto);
    posting.writer = await this.userRepository.findById(userId);

    return this.postingsRepository.save(posting);
  }

  async findAll(dto: SearchPostingDto) {
    return this.postingsRepository.findAll(
      dto.keyword,
      dto.sorting,
      dto.offset,
      dto.limit,
      dto.budget,
      dto.headcount,
      dto.location,
      dto.period,
      dto.season,
      dto.vehicle,
      dto.theme,
      dto.withWho
    );
  }

  async findAllBytitle(keyword: string) {
    const titles = await this.postingsRepository.findAllByTitle(keyword);

    return [
      ...new Set(
        titles
          .filter((e) => e.reports.length <= BLOCKING_LIMIT)
          .map((e) => e.title)
      ),
    ];
  }

  async findAllByWriter(userId: string) {
    return this.postingsRepository.findAllByWriter(userId);
  }

  async findOne(id: string) {
    const posting = await this.postingsRepository.findOne(id);

    if (!posting) {
      throw new NotFoundException('게시글이 존재하지 않습니다.');
    }

    if (posting.reports.length > BLOCKING_LIMIT) {
      throw new ForbiddenException('차단된 게시글입니다.');
    }

    return posting;
  }

  async update(
    postingId: string,
    userId: string,
    updatePostingDto: UpdatePostingDto
  ) {
    const posting = await this.findOne(postingId);

    if (posting.writer.id !== userId) {
      throw new ForbiddenException(
        '본인이 작성한 게시글만 수정할 수 있습니다.'
      );
    }

    const updatedPosting = await this.initialize(updatePostingDto);
    updatedPosting.id = postingId;

    return this.postingsRepository.update(postingId, updatedPosting);
  }

  async remove(postingId: string, userId: string) {
    const posting = await this.findOne(postingId);

    if (posting.writer.id !== userId) {
      throw new ForbiddenException(
        '본인이 작성한 게시글만 삭제할 수 있습니다.'
      );
    }

    return this.postingsRepository.remove(posting);
  }

  async toggleLike(postingId: string, userId: string) {
    await this.findOne(postingId);

    const liked = await this.likedsRepository.findOne(postingId, userId);

    if (liked) {
      return this.likedsRepository.toggle(postingId, userId, liked.isDeleted);
    }

    const newLiked = new Liked();
    newLiked.posting = postingId;
    newLiked.user = userId;
    return this.likedsRepository.save(newLiked);
  }

  async report(postingId: string, userId: string) {
    await this.findOne(postingId);
    const report = await this.reportsRepository.findOne(postingId, userId);

    if (report) {
      throw new ConflictException('이미 신고한 게시글입니다.');
    }

    const newReport = new Report();
    newReport.posting = postingId;
    newReport.reporter = userId;

    return this.reportsRepository.save(newReport);
  }

  private async initialize(
    postingDto: CreatePostingDto | UpdatePostingDto
  ): Promise<Posting> {
    const posting = new Posting();
    posting.title = postingDto.title;
    posting.startDate = new Date(postingDto.startDate);
    posting.endDate = new Date(postingDto.endDate);
    posting.days = this.calculateDays(posting.startDate, posting.endDate);
    posting.period = this.findPeriod(posting.days);
    posting.headcount = postingDto.headcount;
    posting.budget = postingDto.budget;
    posting.location = postingDto.location;
    posting.season = this.findSeason(posting.startDate);
    posting.vehicle = postingDto.vehicle;
    posting.theme = postingDto.theme;
    posting.withWho = postingDto.withWho;
    return posting;
  }

  private calculateDays(startDate: Date, endDate: Date): number {
    return (endDate.getTime() - startDate.getTime()) / (1000 * 3600 * 24) + 1;
  }

  private findPeriod(days: number): Period {
    return days === 1
      ? Period['당일치기']
      : days === 2
      ? Period['1박 2일']
      : days === 3
      ? Period['2박 3일']
      : days < 7
      ? Period['3박 ~']
      : days < 30
      ? Period['일주일 ~']
      : Period['한 달 ~'];
  }

  private findSeason(startDate: Date): Season {
    const month = startDate.getMonth() + 1;
    return month >= 3 && month <= 5
      ? Season.봄
      : month >= 6 && month <= 9
      ? Season.여름
      : month >= 10 && month <= 11
      ? Season.가을
      : Season.겨울;
  }
}
