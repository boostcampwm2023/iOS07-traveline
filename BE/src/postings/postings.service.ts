import { ForbiddenException, Inject, Injectable } from '@nestjs/common';
import { CreatePostingDto } from './dto/create-posting.dto';
import { UpdatePostingDto } from './dto/update-posting.dto';
import { v4 as uuidv4 } from 'uuid';
import { Repository } from 'typeorm';
import { Posting } from './entities/posting.entity';
import { POSTINGS_REPOSITORY } from './postings.constants';
import {
  headcounts,
  budgets,
  locations,
  themes,
  vehicles,
  withWhos,
} from './postings.types';

@Injectable()
export class PostingsService {
  constructor(
    @Inject(POSTINGS_REPOSITORY)
    private readonly postingsRepository: Repository<Posting>
  ) {}

  async create(createPostingDto: CreatePostingDto) {
    const posting = new Posting();
    posting.id = uuidv4();
    posting.writer = '123456789012345678901234567890123456'; // TODO: 나중에 JWT에서 User의 id 가져오기
    posting.title = createPostingDto.title;
    posting.created_at = new Date();
    posting.start_date = new Date(createPostingDto.startDate);
    posting.end_date = new Date(createPostingDto.endDate);
    posting.days = this.calculateDays(posting.start_date, posting.end_date);
    posting.period = this.selectPeriod(posting.days);
    posting.headcount = this.customIndexOf(
      headcounts,
      createPostingDto.headcount
    );
    posting.budget = this.customIndexOf(budgets, createPostingDto.budget);
    posting.location = this.customIndexOf(locations, createPostingDto.location);
    posting.theme = createPostingDto.theme
      ? createPostingDto.theme.map((e) => themes.indexOf(e))
      : null;
    posting.with_who = createPostingDto.withWho
      ? createPostingDto.withWho.map((e) => withWhos.indexOf(e))
      : null;
    posting.season = this.calculateSeason(posting.start_date);
    posting.vehicle = this.customIndexOf(vehicles, createPostingDto.vehicle);

    return this.postingsRepository.save(posting);
  }

  findAll() {
    return `This action returns all postings`;
  }

  async findOne(id: string) {
    return this.postingsRepository.findOneBy({ id });
  }

  async update(
    postingId: string,
    userId: string,
    updatePostingDto: UpdatePostingDto
  ) {
    const posting = await this.postingsRepository.findOneBy({ id: postingId });

    if (posting && posting.writer !== userId) {
      throw new ForbiddenException(
        '본인이 작성한 게시글만 수정할 수 있습니다.'
      );
    }

    const startDate = new Date(updatePostingDto.startDate);
    const endDate = new Date(updatePostingDto.endDate);
    const days = this.calculateDays(startDate, endDate);

    return this.postingsRepository.update(postingId, {
      title: updatePostingDto.title,
      start_date: startDate,
      end_date: endDate,
      days: days,
      period: this.selectPeriod(days),
      headcount: this.customIndexOf(headcounts, updatePostingDto.headcount),
      budget: this.customIndexOf(budgets, updatePostingDto.budget),
      location: this.customIndexOf(locations, updatePostingDto.location),
      theme: updatePostingDto.theme
        ? updatePostingDto.theme.map((e) => themes.indexOf(e))
        : null,
      with_who: updatePostingDto.withWho
        ? updatePostingDto.withWho.map((e) => withWhos.indexOf(e))
        : null,
      season: this.calculateSeason(new Date(updatePostingDto.startDate)),
      vehicle: this.customIndexOf(vehicles, updatePostingDto.vehicle),
    });
  }

  async remove(postingId: string, userId: string) {
    const posting = await this.postingsRepository.findOneBy({ id: postingId });

    if (posting && posting.writer !== userId) {
      throw new ForbiddenException(
        '본인이 작성한 게시글만 삭제할 수 있습니다.'
      );
    }

    return this.postingsRepository.delete({ id: postingId });
  }

  private calculateDays(startDate: Date, endDate: Date): number {
    return (endDate.getTime() - startDate.getTime()) / (1000 * 3600 * 24) + 1;
  }

  private selectPeriod(days: number): number {
    return days === 1
      ? 0
      : days === 2
      ? 1
      : days === 3
      ? 2
      : days < 7
      ? 3
      : days < 30
      ? 4
      : 5;
  }

  private customIndexOf(list: string[], value: string): number | null {
    return list.indexOf(value) > -1 ? list.indexOf(value) : null;
  }

  private calculateSeason(startDate: Date): number {
    const month = startDate.getMonth() + 1;
    return month >= 3 && month <= 5
      ? 0
      : month >= 6 && month <= 9
      ? 1
      : month >= 10 && month <= 11
      ? 2
      : 3;
  }

  createDaysList(startDate: Date, days: number) {
    const weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    const standardDate = new Date(startDate);

    return Array.from({ length: days }, (_, index) => {
      const date = new Date(startDate);
      date.setDate(standardDate.getDate() + index);
      return `${date.getDate()}${weekdays[date.getDay()]}`;
    });
  }
}
