import { Repository } from 'typeorm';

export class PostingMappingRepository<T> {
  constructor(private postingMappingRepository: Repository<T>) {}

  async save(entity: T) {
    return this.postingMappingRepository.save(entity);
  }

  async findAllEntitiesByPosting(postingId: string) {
    return this.postingMappingRepository
      .createQueryBuilder('pm')
      .where('pm.posting = :postingId', { postingId: postingId })
      .getMany();
  }

  async remove(entities: T[]) {
    return this.postingMappingRepository.remove(entities);
  }

  async findAllByPosting(postingId: string) {
    const results = await this.postingMappingRepository
      .createQueryBuilder('pm')
      .leftJoinAndSelect('pm.tag', 't')
      .where('pm.posting = :postingId', { postingId: postingId })
      .getMany();

    return results.map((e) => e['tag'].name);
  }
}
