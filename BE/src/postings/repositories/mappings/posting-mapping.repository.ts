import { Repository } from 'typeorm';

export class PostingMappingRepository<T> {
  constructor(private postingMappingRepository: Repository<T>) {}

  async save(entity: T) {
    return this.postingMappingRepository.save(entity);
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
