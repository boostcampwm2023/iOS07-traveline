import { Inject, Injectable } from '@nestjs/common';
import { Repository, UpdateResult } from 'typeorm';
import { User } from './entities/user.entity';
import { UpdateUserDto } from './dto/update-user.dto';

@Injectable()
export class UserRepository {
  constructor(
    @Inject('USERS_REPOSITORY')
    private userRepository: Repository<User>
  ) {}

  update(id, updateUserDto: UpdateUserDto): Promise<UpdateResult> {
    return this.userRepository.update({ id: id }, updateUserDto);
  }
  findById(id: string): Promise<User> {
    return this.userRepository.findOne({ where: { id: id } });
  }

  findByName(name: string): Promise<User> {
    return this.userRepository.findOne({ where: { name: name } });
  }
}
