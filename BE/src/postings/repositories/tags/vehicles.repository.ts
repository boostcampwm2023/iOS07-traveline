import { VEHICLES_REPOSITORY } from '../../postings.constants';
import { Vehicle } from '../../entities/tags/vehicle.entity';
import { Inject, Injectable } from '@nestjs/common';
import { TagRepository } from './tag.repository';
import { Repository } from 'typeorm';

@Injectable()
export class VehiclesRepository extends TagRepository<Vehicle> {
  constructor(
    @Inject(VEHICLES_REPOSITORY)
    private vehiclesRepository: Repository<Vehicle>
  ) {
    super(vehiclesRepository);
  }
}
