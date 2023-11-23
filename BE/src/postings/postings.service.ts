import {
  ConflictException,
  ForbiddenException,
  Inject,
  Injectable,
} from '@nestjs/common';
import { CreatePostingDto } from './dto/create-posting.dto';
import { UpdatePostingDto } from './dto/update-posting.dto';
import { v4 as uuidv4 } from 'uuid';
import { Posting } from './entities/posting.entity';
import {
  headcounts,
  budgets,
  locations,
  themes,
  vehicles,
  withWhos,
} from './postings.types';
import { LikedsRepository } from './repositories/likeds.repository';
import { PostingThemesRepository } from './repositories/mappings/posting-themes.repository';
import { PostingWithWhosRepository } from './repositories/mappings/posting-with-whos.repository';
import { PostingsRepository } from './repositories/postings.repository';
import { ReportsRepository } from './repositories/reports.repository';
import { BudgetsRepository } from './repositories/tags/budgets.repository';
import { HeadcountsRepository } from './repositories/tags/headcounts.repository';
import { LocationsRepository } from './repositories/tags/locations.repository';
import { PeriodsRepository } from './repositories/tags/periods.repository';
import { SeasonsRepository } from './repositories/tags/seasons.repository';
import { ThemesRepository } from './repositories/tags/themes.repository';
import { VehiclesRepository } from './repositories/tags/vehicles.repository';
import { WithWhosRepository } from './repositories/tags/with-whos.repository';
import { PostingTheme } from './entities/mappings/posting-theme.entity';
import { PostingWithWho } from './entities/mappings/posting-with-who.entity';

@Injectable()
export class PostingsService {
  constructor(
    private readonly postingsRepository: PostingsRepository,
    private readonly likedsRepository: LikedsRepository,
    private readonly reportsRepository: ReportsRepository,
    private readonly budgetsRepository: BudgetsRepository,
    private readonly headcountsRepository: HeadcountsRepository,
    private readonly locationsRepository: LocationsRepository,
    private readonly periodsRepository: PeriodsRepository,
    private readonly seasonsRepository: SeasonsRepository,
    private readonly themesRepository: ThemesRepository,
    private readonly vehiclesRepository: VehiclesRepository,
    private readonly withWhosRepository: WithWhosRepository,
    private readonly postingThemesRepository: PostingThemesRepository,
    private readonly postingWithWhosRepository: PostingWithWhosRepository
  ) {}

  async createPosting(userId: string, createPostingDto: CreatePostingDto) {
    const posting = new Posting();
    posting.id = uuidv4();
    posting.writer = userId;
    posting.title = createPostingDto.title;
    posting.createdAt = new Date();
    posting.startDate = new Date(createPostingDto.startDate);
    posting.endDate = new Date(createPostingDto.endDate);
    posting.days = this.calculateDays(posting.startDate, posting.endDate);
    posting.period = await this.periodsRepository.findByName(
      this.periodsRepository.findNameByCalculatingDays(posting.days)
    );
    posting.headcount = await this.headcountsRepository.findByName(
      createPostingDto.headcount
    );
    posting.budget = await this.budgetsRepository.findByName(
      createPostingDto.budget
    );
    posting.location = await this.locationsRepository.findByName(
      createPostingDto.location
    );
    posting.season = await this.seasonsRepository.findByName(
      this.seasonsRepository.findNameByCalculatingStartDate(posting.startDate)
    );
    posting.vehicle = await this.vehiclesRepository.findByName(
      createPostingDto.vehicle
    );

    return this.postingsRepository.save(posting);
  }

  async createPostingTheme(postingId: string, themes: string[]) {
    themes.forEach(async (e) => {
      const themeId = await this.themesRepository.findByName(e);
      const postingTheme = new PostingTheme();
      postingTheme.posting = postingId;
      postingTheme.theme = themeId.id;
      await this.postingThemesRepository.save(postingTheme);
    });
  }

  async createPostingWithWho(postingId: string, withWhos: string[]) {
    withWhos.forEach(async (e) => {
      const withWhoId = await this.withWhosRepository.findByName(e);
      const postingWithWho = new PostingWithWho();
      postingWithWho.posting = postingId;
      postingWithWho.withWho = withWhoId.id;
      await this.postingWithWhosRepository.save(postingWithWho);
    });
  }

  // findAll() {
  //   return `This action returns all postings`;
  // }

  // async findOne(id: string) {
  //   return this.postingsRepository.findOneBy({ id });
  // }

  // async update(
  //   postingId: string,
  //   userId: string,
  //   updatePostingDto: UpdatePostingDto
  // ) {
  //   const posting = await this.postingsRepository.findOneBy({ id: postingId });

  //   if (posting && posting.writer !== userId) {
  //     throw new ForbiddenException(
  //       '본인이 작성한 게시글만 수정할 수 있습니다.'
  //     );
  //   }

  //   const startDate = new Date(updatePostingDto.startDate);
  //   const endDate = new Date(updatePostingDto.endDate);
  //   const days = this.calculateDays(startDate, endDate);

  //   return this.postingsRepository.update(postingId, {
  //     title: updatePostingDto.title,
  //     start_date: startDate,
  //     end_date: endDate,
  //     days: days,
  //     period: this.selectPeriod(days),
  //     headcount: this.customIndexOf(headcounts, updatePostingDto.headcount),
  //     budget: this.customIndexOf(budgets, updatePostingDto.budget),
  //     location: this.customIndexOf(locations, updatePostingDto.location),
  //     theme: updatePostingDto.theme
  //       ? updatePostingDto.theme.map((e) => themes.indexOf(e))
  //       : null,
  //     with_who: updatePostingDto.withWho
  //       ? updatePostingDto.withWho.map((e) => withWhos.indexOf(e))
  //       : null,
  //     season: this.calculateSeason(new Date(updatePostingDto.startDate)),
  //     vehicle: this.customIndexOf(vehicles, updatePostingDto.vehicle),
  //   });
  // }

  // async remove(postingId: string, userId: string) {
  //   const posting = await this.postingsRepository.findOneBy({ id: postingId });

  //   if (posting && posting.writer !== userId) {
  //     throw new ForbiddenException(
  //       '본인이 작성한 게시글만 삭제할 수 있습니다.'
  //     );
  //   }

  //   return this.postingsRepository.delete({ id: postingId });
  // }

  // async toggleLike(postingId: string, userId: string) {
  //   const liked = await this.likedsRepository.findOneBy({
  //     posting: postingId,
  //     user: userId,
  //   });

  //   if (liked) {
  //     return this.likedsRepository.delete({ posting: postingId, user: userId });
  //   }

  //   const newLiked = new Liked();
  //   newLiked.posting = postingId;
  //   newLiked.user = userId;

  //   return this.likedsRepository.save(newLiked);
  // }

  // async report(postingId: string, userId: string) {
  //   const report = await this.reportsRepository.findOneBy({
  //     posting: postingId,
  //     reporter: userId,
  //   });

  //   if (report) {
  //     throw new ConflictException('이미 신고한 게시글입니다.');
  //   }

  //   const newReport = new Report();
  //   newReport.posting = postingId;
  //   newReport.reporter = userId;

  //   return this.reportsRepository.save(newReport);
  // }

  private calculateDays(startDate: Date, endDate: Date): number {
    return (endDate.getTime() - startDate.getTime()) / (1000 * 3600 * 24) + 1;
  }

  // createDaysList(startDate: Date, days: number) {
  //   const weekdays = ['일', '월', '화', '수', '목', '금', '토'];
  //   const standardDate = new Date(startDate);

  //   return Array.from({ length: days }, (_, index) => {
  //     const date = new Date(startDate);
  //     date.setDate(standardDate.getDate() + index);
  //     return `${date.getDate()}${weekdays[date.getDay()]}`;
  //   });
  // }
}
