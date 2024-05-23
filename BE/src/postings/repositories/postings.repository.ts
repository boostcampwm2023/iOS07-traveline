import { BLOCKING_LIMIT, POSTINGS_REPOSITORY } from '../postings.constants';
import { Posting } from '../entities/posting.entity';
import { Inject, Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
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
    return this.postingsRepository
      .createQueryBuilder('p')
      .leftJoinAndSelect('p.writer', 'w')
      .leftJoinAndSelect('p.reports', 'r')
      .leftJoinAndSelect('p.likeds', 'l', 'l.isDeleted = false')
      .where('p.id = :id', { id })
      .getOne();
  }

  async findAll(
    blockedIds: string[],
    keyword: string,
    sorting: Sorting,
    offset: number,
    limit: number,
    budget: Budget,
    headcount: Headcount,
    locations: Location[],
    period: Period,
    seasons: Season[],
    vehicle: Vehicle,
    themes: Theme[],
    withWhos: WithWho[]
  ) {
    const conditions = ['p.title LIKE :keyword'];
    let params: { [key: string]: string | string[] } = {
      keyword: `%${keyword}%`,
    };

    if (blockedIds.length > 0) {
      conditions.push('p.writer NOT IN (:...blockedIds)');
      params = { ...params, blockedIds };
    }

    if (budget) {
      conditions.push('p.budget = :budget');
      params = { ...params, budget };
    }

    if (headcount) {
      conditions.push('p.headcount = :headcount');
      params = { ...params, headcount };
    }

    if (period) {
      conditions.push('p.period = :period');
      params = { ...params, period };
    }

    if (vehicle) {
      conditions.push('p.vehicle = :vehicle');
      params = { ...params, vehicle };
    }

    if (locations) {
      const sql = locations
        .map((location, index) => `p.location = :location${index}`)
        .join(' OR ');
      const tagParams = locations.reduce(
        (params, location, index) => ({
          ...params,
          [`location${index}`]: location,
        }),
        {}
      );
      conditions.push(`(${sql})`);
      params = { ...params, ...tagParams };
    }

    if (seasons) {
      const sql = seasons
        .map((season, index) => `p.season = :season${index}`)
        .join(' OR ');
      const tagParams = seasons.reduce(
        (params, season, index) => ({
          ...params,
          [`season${index}`]: season,
        }),
        {}
      );
      conditions.push(`(${sql})`);
      params = { ...params, ...tagParams };
    }

    if (themes) {
      const sql = themes
        .map((theme, index) => `JSON_CONTAINS(p.theme, :theme${index})`)
        .join(' OR ');
      const tagParams = themes.reduce(
        (params, theme, index) => ({
          ...params,
          [`theme${index}`]: JSON.stringify(theme),
        }),
        {}
      );
      conditions.push(`(${sql})`);
      params = { ...params, ...tagParams };
    }

    if (withWhos) {
      const sql = withWhos
        .map((withWho, index) => `JSON_CONTAINS(p.withWho, :withWho${index})`)
        .join(' OR ');
      const tagParams = withWhos.reduce(
        (params, withWho, index) => ({
          ...params,
          [`withWho${index}`]: JSON.stringify(withWho),
        }),
        {}
      );
      conditions.push(`(${sql})`);
      params = { ...params, ...tagParams };
    }

    const sql = conditions.join(' AND ');
    const qb = this.postingsRepository
      .createQueryBuilder('p')
      .leftJoinAndSelect('p.writer', 'u')
      .where(sql, params)
      .leftJoin('p.likeds', 'l', 'l.isDeleted = :isDeleted', {
        isDeleted: false,
      })
      .addSelect('COUNT(l.posting)', 'likeds')
      .leftJoin('p.reports', 'r')
      .having('COUNT(r.posting) <= :BLOCKING_LIMIT', { BLOCKING_LIMIT })
      .groupBy('p.id');

    if (sorting == Sorting.좋아요순) {
      qb.orderBy('likeds', 'DESC');
    } else {
      qb.orderBy('p.createdAt', 'DESC');
    }

    return qb
      .offset((offset - 1) * limit)
      .limit(limit)
      .getRawMany();
  }

  async findAllByTitle(keyword: string) {
    return this.postingsRepository
      .createQueryBuilder('p')
      .select('DISTINCT p.title', 'title')
      .where('p.title LIKE :keyword', { keyword: `%${keyword}%` })
      .leftJoin('p.reports', 'r')
      .groupBy('p.id')
      .having('COUNT(r.posting) <= :BLOCKING_LIMIT', { BLOCKING_LIMIT })
      .getRawMany();
  }

  async findAllByWriter(userId: string) {
    return this.postingsRepository
      .createQueryBuilder('p')
      .leftJoinAndSelect('p.writer', 'u')
      .where('p.writer = :userId', { userId })
      .leftJoin('p.likeds', 'l', 'l.isDeleted = :isDeleted', {
        isDeleted: false,
      })
      .addSelect('COUNT(l.posting)', 'likeds')
      .leftJoin('p.reports', 'r')
      .addSelect('COUNT(r.posting)', 'reports')
      .groupBy('p.id')
      .orderBy('p.createdAt', 'DESC')
      .getRawMany();
  }

  async update(id: string, posting: Posting) {
    return this.postingsRepository.update(id, posting);
  }

  async remove(posting: Posting) {
    return this.postingsRepository.remove(posting);
  }

  async updateThumbnail(id: string, thumbnail: string) {
    return this.postingsRepository.update(id, { thumbnail });
  }
}
