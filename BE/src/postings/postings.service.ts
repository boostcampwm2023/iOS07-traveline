import {
  ConflictException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { CreatePostingDto } from './dto/create-posting.dto';
import { UpdatePostingDto } from './dto/update-posting.dto';
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
import { UserRepository } from 'src/users/users.repository';
import { Liked } from './entities/liked.entity';
import { Report } from './entities/report.entity';

@Injectable()
export class PostingsService {
  constructor(
    private readonly userRepository: UserRepository,
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
    const posting = await this.initializePosting(createPostingDto);
    posting.writer = await this.userRepository.findById(userId);

    const savedPosting = await this.postingsRepository.save(posting);
    const postingTheme = await this.createPostingTheme(
      savedPosting,
      createPostingDto.theme
    );
    const postingWithWho = await this.createPostingWithWho(
      savedPosting,
      createPostingDto.withWho
    );

    return { ...savedPosting, postingTheme, postingWithWho };
  }

  async createPostingTheme(posting: Posting, themes: string[]) {
    return !!themes
      ? Promise.all(
          themes.map(async (e) => {
            const postingTheme = new PostingTheme();
            postingTheme.posting = posting;
            postingTheme.tag = await this.themesRepository.findByName(e);
            return this.postingThemesRepository.save(postingTheme);
          })
        )
      : undefined;
  }

  async createPostingWithWho(posting: Posting, withWhos: string[]) {
    return !!withWhos
      ? Promise.all(
          withWhos.map(async (e) => {
            const postingWithWho = new PostingWithWho();
            postingWithWho.posting = posting;
            postingWithWho.tag = await this.withWhosRepository.findByName(e);
            return this.postingWithWhosRepository.save(postingWithWho);
          })
        )
      : undefined;
  }

  // findAll() {
  //   return `This action returns all postings`;
  // }

  async findPosting(id: string) {
    const [posting, theme, withWho] = await Promise.all([
      this.postingsRepository.findOne(id),
      this.postingThemesRepository.findAllByPosting(id),
      this.postingWithWhosRepository.findAllByPosting(id),
    ]);

    return { ...posting, theme, withWho };
  }

  async updatePosting(
    postingId: string,
    userId: string,
    updatePostingDto: UpdatePostingDto
  ) {
    const posting = await this.postingsRepository.findOne(postingId);

    if (!posting) {
      throw new NotFoundException('게시글이 존재하지 않습니다.');
    }

    if (posting.writer.id !== userId) {
      throw new ForbiddenException(
        '본인이 작성한 게시글만 수정할 수 있습니다.'
      );
    }

    const updatedPosting = await this.initializePosting(updatePostingDto);
    updatedPosting.id = postingId;

    const [, theme, withWho] = await Promise.all([
      this.postingsRepository.update(postingId, updatedPosting),
      this.updatePostingTheme(updatedPosting, updatePostingDto.theme),
      this.updatePostingWithWho(updatedPosting, updatePostingDto.withWho),
    ]);

    return { ...updatedPosting, theme, withWho };
  }

  async updatePostingTheme(posting: Posting, themes: string[]) {
    const outdated =
      await this.postingThemesRepository.findAllEntitiesByPosting(posting.id);

    await this.removePostingTheme(outdated);
    return this.createPostingTheme(posting, themes);
  }

  async updatePostingWithWho(posting: Posting, withWhos: string[]) {
    const outdated =
      await this.postingWithWhosRepository.findAllEntitiesByPosting(posting.id);

    await this.removePostingWithWho(outdated);
    return this.createPostingWithWho(posting, withWhos);
  }

  async removePosting(postingId: string, userId: string) {
    const posting = await this.postingsRepository.findOne(postingId);

    if (!posting) {
      throw new NotFoundException('게시글이 존재하지 않습니다.');
    }

    if (posting.writer.id !== userId) {
      throw new ForbiddenException(
        '본인이 작성한 게시글만 삭제할 수 있습니다.'
      );
    }

    return this.postingsRepository.remove(posting);
  }

  async removePostingTheme(postingThemes: PostingTheme[]) {
    return this.postingThemesRepository.remove(postingThemes);
  }

  async removePostingWithWho(postingWithWhos: PostingWithWho[]) {
    return this.postingWithWhosRepository.remove(postingWithWhos);
  }

  async toggleLike(postingId: string, userId: string) {
    const posting = await this.postingsRepository.findOne(postingId);

    if (!posting) {
      throw new NotFoundException('게시글이 존재하지 않습니다.');
    }

    const liked = await this.likedsRepository.findOne(postingId, userId);

    if (liked) {
      const newLiked = new Liked();
      newLiked.posting = postingId;
      newLiked.user = userId;
      return this.likedsRepository.save(newLiked);
    }

    return this.likedsRepository.toggle(liked);
  }

  async report(postingId: string, userId: string) {
    const posting = await this.postingsRepository.findOne(postingId);

    if (!posting) {
      throw new NotFoundException('게시글이 존재하지 않습니다.');
    }

    const report = await this.reportsRepository.findOne(postingId, userId);

    if (report) {
      throw new ConflictException('이미 신고한 게시글입니다.');
    }

    const newReport = new Report();
    newReport.posting = postingId;
    newReport.reporter = userId;

    return this.reportsRepository.save(newReport);
  }

  private calculateDays(startDate: Date, endDate: Date): number {
    return (endDate.getTime() - startDate.getTime()) / (1000 * 3600 * 24) + 1;
  }

  private async initializePosting(
    postingDto: CreatePostingDto | UpdatePostingDto
  ): Promise<Posting> {
    const posting = new Posting();

    posting.title = postingDto.title;
    posting.startDate = new Date(postingDto.startDate);
    posting.endDate = new Date(postingDto.endDate);
    posting.days = this.calculateDays(posting.startDate, posting.endDate);
    [
      posting.period,
      posting.headcount,
      posting.budget,
      posting.location,
      posting.season,
      posting.vehicle,
    ] = await Promise.all([
      this.periodsRepository.findByName(
        this.periodsRepository.findNameByCalculatingDays(posting.days)
      ),
      this.headcountsRepository.findByName(postingDto.headcount),
      this.budgetsRepository.findByName(postingDto.budget),
      this.locationsRepository.findByName(postingDto.location),
      this.seasonsRepository.findByName(
        this.seasonsRepository.findNameByCalculatingStartDate(posting.startDate)
      ),
      this.vehiclesRepository.findByName(postingDto.vehicle),
    ]);

    return posting;
  }
}
