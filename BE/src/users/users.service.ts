import { Injectable } from '@nestjs/common';
import { UpdateUserDto } from './dto/update-user.dto';
import { CreateAuthDto } from 'src/auth/dto/create-auth.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User) private userRepository: Repository<User>
  ) {
    this.userRepository = userRepository;
  }

  create(createAuthDto: CreateAuthDto) {
    return 'This action adds a new user';
  }

  findOne(id: string): Promise<User> {
    //가져온 이미지 정보로 이미지 url 전달
    return this.userRepository.findOne({ where: { id: id } });
  }

  update(id: string, updateUserDto: UpdateUserDto) {
    //이미지 업로드 작업
    return this.userRepository.update({ id: id }, updateUserDto);
  }

  async checkDuplicatedName(name: string) {
    const duplicatedUser = await this.userRepository.findOne({
      where: { name: name },
    });
    if (duplicatedUser === undefined) {
      return true;
    }
    return false;
  }

  remove(id: number) {
    return `This action removes a #${id} user`;
  }
}
