import { HttpException, Injectable } from '@nestjs/common';
import { UpdateUserDto } from './dto/update-user.dto';
import { CreateAuthDto } from 'src/auth/dto/create-auth.dto';
import { User } from './entities/user.entity';
import { StorageService } from 'src/storage/storage.service';
import { UserRepository } from './users.repository';
import { CheckDuplicatedNameResponseDto } from './dto/check-duplicated-name-response.dto';

@Injectable()
export class UsersService {
  constructor(
    private userRepository: UserRepository,
    private readonly storageService: StorageService
  ) {}

  create(createAuthDto: CreateAuthDto) {
    return 'This action adds a new user';
  }

  async findById(id: string): Promise<User> {
    const user = await this.userRepository.findById(id);
    if (!user) {
      throw new HttpException('Not Found', 404);
    }
    const avatarPath = user.avatar;
    user.avatar = await this.storageService.getImageUrl(avatarPath);
    return user;
  }

  async update(
    id: string,
    updateUserDto: UpdateUserDto,
    file: Express.Multer.File
  ) {
    if (file) {
      const uploadResult = await this.storageService.upload('avatar/', file);
      const path = uploadResult.path;
      updateUserDto.avatar = path;
    }
    const updateResult = await this.userRepository.update(id, updateUserDto);
    if (updateResult.affected == 0) {
      throw new HttpException('Bad Request', 400);
    }
    const url = await this.storageService.getImageUrl(updateUserDto.avatar);
    return { imageUrl: url };
  }

  async checkDuplicatedName(
    name: string
  ): Promise<CheckDuplicatedNameResponseDto> {
    const duplicatedUser = await this.userRepository.findByName(name);
    if (!duplicatedUser) {
      return { isDuplicated: false };
    }
    return { isDuplicated: true };
  }

  remove(id: number) {
    return `This action removes a #${id} user`;
  }
}
