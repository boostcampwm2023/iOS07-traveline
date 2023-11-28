import { POSTINGS_REPOSITORY } from '../postings.constants';
import { Posting } from '../entities/posting.entity';
import { Inject, Injectable } from '@nestjs/common';
import { Like, Repository } from 'typeorm';

@Injectable()
export class PostingsRepository {
  constructor(
    @Inject(POSTINGS_REPOSITORY)
    private postingsRepository: Repository<Posting>
  ) {}

  async save(posting: Posting) {
    return this.postingsRepository.save(posting);
  }

  async findOne(id: string) {
    return this.postingsRepository.findOne({
      where: { id },
      relations: {
        writer: true,
      },
    });
  }

  async findAllByTitle(keyword: string) {
    return this.postingsRepository.find({
      where: { title: Like(`${keyword}%`) },
      select: ['title'],
    });
  }

  async update(id: string, posting: Posting) {
    return this.postingsRepository.update(id, posting);
  }

  async remove(posting: Posting) {
    return this.postingsRepository.remove(posting);
  }
}
