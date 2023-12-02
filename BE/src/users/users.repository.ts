import { Inject, Injectable } from '@nestjs/common';
import { DeleteResult, Repository, UpdateResult } from 'typeorm';
import { User } from './entities/user.entity';
import { USERS_REPOSITORY } from './users.constants';
import { CreateUserDto } from './dto/create-user.dto';

@Injectable()
export class UserRepository {
  constructor(
    @Inject(USERS_REPOSITORY)
    private userRepository: Repository<User>
  ) {}

  save(createUserDto: CreateUserDto) {
    return this.userRepository.save(createUserDto);
  }

  update(id, option): Promise<UpdateResult> {
    return this.userRepository.update(id, option);
  }

  delete(id): Promise<DeleteResult> {
    return this.userRepository.delete({ id });
  }

  findById(id: string): Promise<User> {
    return this.userRepository.findOne({ where: { id: id } });
  }

  findByName(name: string): Promise<User> {
    return this.userRepository.findOne({ where: { name: name } });
  }

  findByResourceId(resourceId: string): Promise<User> {
    return this.userRepository.findOne({ where: { resourceId: resourceId } });
  }
}
