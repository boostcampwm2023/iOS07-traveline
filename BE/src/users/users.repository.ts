import { Inject, Injectable } from '@nestjs/common';
import { Repository, UpdateResult } from 'typeorm';
import { User } from './entities/user.entity';
import { UserInfoDto } from './dto/user-info.dto';

@Injectable()
export class UserRepository {
  constructor(
    @Inject('USERS_REPOSITORY')
    private userRepository: Repository<User>
  ) {}

  update(id, updateUserDto: UserInfoDto): Promise<UpdateResult> {
    return this.userRepository.update(id, updateUserDto);
  }
  findById(id: string): Promise<User> {
    return this.userRepository.findOne({ where: { id: id } });
  }

  findByName(name: string): Promise<User> {
    return this.userRepository.findOne({ where: { name: name } });
  }
}
