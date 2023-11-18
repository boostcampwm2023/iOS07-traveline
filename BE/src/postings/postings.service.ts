import { Inject, Injectable } from '@nestjs/common';
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
    posting.period = this.calculateDays(posting.start_date, posting.end_date); //
    posting.headcount = this.customIndexOf(
      headcounts,
      createPostingDto.headcount
    );
    posting.budget = this.customIndexOf(budgets, createPostingDto.budget);
    posting.location = this.customIndexOf(locations, createPostingDto.location);
    posting.theme = this.transformToTagObject(themes, createPostingDto.theme);
    posting.with_who = this.transformToTagObject(
      withWhos,
      createPostingDto.withWho
    );
    posting.season = this.calculateSeason(posting.start_date);
    posting.vehicle = this.customIndexOf(vehicles, createPostingDto.vehicle);

    return this.postingsRepository.save(posting);
  }

  findAll() {
    return `This action returns all postings`;
  }

  findOne(id: number) {
    return `This action returns a #${id} posting`;
  }

  update(id: number, updatePostingDto: UpdatePostingDto) {
    return `This action updates a #${id} posting`;
  }

  remove(id: number) {
    return `This action removes a #${id} posting`;
  }

  private calculateDays(startDate: Date, endDate: Date) {
    return (endDate.getTime() - startDate.getTime()) / (1000 * 3600 * 24) + 1;
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

  private transformToTagObject(tags: string[], selectedTags: string[]) {
    return this.updateTagObject(this.createTagObject(tags), selectedTags);
  }

  private updateTagObject(
    object: { [key: string]: boolean },
    selectedTags: string[]
  ): { [key: string]: boolean } {
    return !!selectedTags
      ? {
          ...object,
          ...Object.fromEntries(selectedTags.map((e) => [e, true])),
        }
      : object;
  }

  private createTagObject(tags: string[]): { [key: string]: boolean } {
    return tags.reduce((result, e) => {
      result[e] = false;
      return result;
    }, {});
  }
}
