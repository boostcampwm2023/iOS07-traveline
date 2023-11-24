import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
} from '@nestjs/common';
import { UserInfoDto } from './dto/user-info.dto';
import { CreateAuthDto } from 'src/auth/dto/create-auth.dto';
import { StorageService } from 'src/storage/storage.service';
import { UserRepository } from './users.repository';
import { CheckDuplicatedNameResponseDto } from './dto/check-duplicated-name-response.dto';

@Injectable()
export class UsersService {
  constructor(
    private userRepository: UserRepository,
    private readonly storageService: StorageService
  ) {}

  createUser(createAuthDto: CreateAuthDto) {
    return 'This action adds a new user';
  }

  deleteUser(id: number) {
    return `This action removes a #${id} user`;
  }

  async getUserInfo(id: string): Promise<UserInfoDto> {
    const user = await this.userRepository.findById(id);
    const avatarPath = user.avatar;
    user.avatar = await this.storageService.getImageUrl(avatarPath);
    return { name: user.name, avatar: user.avatar };
  }

  async updateUserInfo(
    id,
    userInfoDto: UserInfoDto,
    file: Express.Multer.File
  ) {
    const user = await this.userRepository.findById(id);

    //프로필사진, 닉네임 변화 모두 없음
    if (!file && userInfoDto.name === user.name) {
      throw new BadRequestException('변경 사항이 없습니다.');
    }

    //닉네임만 변경
    if (!file) {
      userInfoDto.avatar = user.avatar;
    }

    //닉네임과 프로필 모두 변경
    else {
      if (user.avatar != 'default') {
        const deleteResult = await this.storageService.delete(user.avatar);
        console.log(deleteResult);
      }
      const uploadResult = await this.storageService.upload(`${id}/`, file);
      const path = uploadResult.path;
      userInfoDto.avatar = path;
    }

    const updateResult = await this.userRepository.update(id, userInfoDto);
    if (updateResult.affected == 0) {
      throw new InternalServerErrorException();
    }

    userInfoDto.avatar = await this.storageService.getImageUrl(
      userInfoDto.avatar
    );
    return userInfoDto;
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
}
