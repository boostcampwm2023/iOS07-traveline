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
    try {
      user.avatar = await this.storageService.getImageUrl(avatarPath);
    } catch {
      throw new InternalServerErrorException(
        '사용자 프로필 사진을 찾을 수 없습니다.'
      );
    }
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
        try {
          await this.storageService.delete(user.avatar);
        } catch (error) {
          throw new InternalServerErrorException(
            '사용자의 기존 프로필 사진 삭제에 실패하였습니다.'
          );
        }
        return true;
      }

      try {
        const uploadResult = await this.storageService.upload(`${id}/`, file);
        const path = uploadResult.path;
        userInfoDto.avatar = path;
      } catch {
        throw new InternalServerErrorException(
          '새로운 프로필 사진 업로드에 실패하였습니다.'
        );
      }
    }
    try {
      await this.userRepository.update(id, userInfoDto);
    } catch {
      throw new InternalServerErrorException(
        '사용자 정보 갱신에 실패하였습니다.'
      );
    }

    try {
      userInfoDto.avatar = await this.storageService.getImageUrl(
        userInfoDto.avatar
      );
    } catch {
      throw new InternalServerErrorException(
        '사용자 프로필 사진을 찾을 수 없습니다.'
      );
    }

    return userInfoDto;
  }

  async checkDuplicatedName(
    name: string
  ): Promise<CheckDuplicatedNameResponseDto> {
    try {
      const duplicatedUser = await this.userRepository.findByName(name);
      if (!duplicatedUser) {
        return { isDuplicated: false };
      }
      return { isDuplicated: true };
    } catch {
      throw new InternalServerErrorException(
        '닉네임 중복 검사에 실패하였습니다.'
      );
    }
  }
}
