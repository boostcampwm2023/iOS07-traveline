import { POSTINGS_REPOSITORY } from '../postings.constants';
import { Posting } from '../entities/posting.entity';
import { Inject, Injectable } from '@nestjs/common';
import { Like, Repository } from 'typeorm';
import {
  Budget,
  Headcount,
  Sorting,
  Location,
  Period,
  Season,
  Vehicle,
  Theme,
  WithWho,
} from '../postings.types';

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
    sorting: Sorting,
    offset: number,
    limit: number,
    budget: Budget,
    headcount: Headcount,
    location: Location,
    period: Period,
    season: Season,
    vehicle: Vehicle,
    theme: Theme,
    withWho: WithWho
  ) {
    const qb = this.postingsRepository
      .createQueryBuilder('p')
      .leftJoinAndSelect('p.writer', 'user')
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

    if (sorting === Sorting.좋아요순) {
      qb.leftJoin('p.likeds', 'liked', 'liked.isDeleted = :isDeleted', {
        isDeleted: false,
      })
        .groupBy('p.id')
        .addSelect('COUNT(liked.posting)', 'likedCount')
        .orderBy('likedCount', 'DESC');
    } else {
      qb.orderBy('p.createdAt', 'DESC');
    }

    return qb.offset(offset).limit(limit).getMany();
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
