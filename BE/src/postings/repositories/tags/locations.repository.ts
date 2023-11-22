import { LOCATIONS_REPOSITORY } from '../../postings.constants';
import { Location } from '../../entities/tags/location.entity';
import { Inject, Injectable } from '@nestjs/common';
import { TagRepository } from './tag.repository';
import { Repository } from 'typeorm';

@Injectable()
export class LocationsRepository extends TagRepository<Location> {
  constructor(
    @Inject(LOCATIONS_REPOSITORY)
    private locationsRepository: Repository<Location>
  ) {
    super(locationsRepository);
  }
}
