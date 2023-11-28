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

  async findAll(
    keyword: string,
    sorting: string,
    offset: number,
    limit: number,
    budget: string,
    headcount: string,
    location: string,
    period: string,
    season: string,
    vehicle: string,
    theme: string,
    withWho: string
  ) {
    const qb = this.postingsRepository
      .createQueryBuilder('p')
      .where('p.title LIKE :keyword', { keyword: `%${keyword}%` });

    if (budget) {
      qb.where('p.budget = :budget', { budget });
    }

    if (headcount) {
      qb.andWhere('p.headcount = :headcount', { headcount });
    }

    if (location) {
      qb.andWhere('p.location = :location', { location });
    }
    if (period) {
      qb.andWhere('p.period = :period', { period });
    }
    if (season) {
      qb.andWhere('p.season = :season', { season });
    }
    if (vehicle) {
      qb.andWhere('p.vehicle = :vehicle', { vehicle });
    }
    if (theme) {
      qb.andWhere('JSON_CONTAINS(p.theme, :theme)', {
        theme: JSON.stringify(theme),
      });
    }
    if (withWho) {
      qb.andWhere('JSON_CONTAINS(p.withWho, :withWho)', {
        withWho: JSON.stringify(withWho),
      });
    }

    return qb
      .offset(offset)
      .limit(limit)
      .orderBy('p.createdAt', 'DESC')
      .getMany();
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
