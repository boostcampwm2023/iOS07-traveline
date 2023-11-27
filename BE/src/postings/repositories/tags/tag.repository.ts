import { Repository } from 'typeorm';

export class TagRepository<T> {
  constructor(private readonly tagRepository: Repository<T>) {}

  async findByName(name: string) {
    return this.tagRepository
      .createQueryBuilder('r')
      .where('r.name = :name', { name })
      .getOne();
  }
}
