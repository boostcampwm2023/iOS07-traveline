import { Repository } from 'typeorm';

export class PostingMappingRepository<T> {
  constructor(private postingMappingRepository: Repository<T>) {}

  async save(entity: T) {
    return this.postingMappingRepository.save(entity);
  }
}
