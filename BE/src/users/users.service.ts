import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
} from '@nestjs/common';
import { UserInfoDto } from './dto/user-info.dto';
import { StorageService } from 'src/storage/storage.service';
import { UserRepository } from './users.repository';
import { CheckDuplicatedNameResponseDto } from './dto/check-duplicated-name-response.dto';

@Injectable()
export class UsersService {
  constructor(
    private userRepository: UserRepository,
    private readonly storageService: StorageService
  ) {}

  nameGenerator() {
    const length = Math.floor(Math.random() * 14) + 1;
    const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
    let name = '';
    for (let i = 0; i < length; i++) {
      const randomIndex = Math.floor(Math.random() * characters.length);
      name += characters[randomIndex];
    }
    return name;
  }

  async createUser(resourceId: string) {
    let name = this.nameGenerator();
    while (true) {
      const user = await this.userRepository.findByName(name);
      if (!user) {
        break;
      }
      name = this.nameGenerator();
    }
    const socialType = 1;
    const createUserDto = { name, resourceId, socialType };
    return this.userRepository.save(createUserDto);
  }

  deleteUser(id: number) {
    return `This action removes a #${id} user`;
  }

  async findUserById(id: string) {
    return this.userRepository.findById(id);
  }

  async getUserInfoById(id: string): Promise<UserInfoDto> {
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

  async getUserInfoByResourceId(resourceId: string) {
    return this.userRepository.findByResourceId(resourceId);
  }

  async updateUserInfo(id, name: string, file: Express.Multer.File) {
    const user = await this.userRepository.findById(id);
    const result = new UserInfoDto();

    //프로필사진, 닉네임 변화 모두 없음
    if (!file && name === user.name) {
      throw new BadRequestException('변경 사항이 없습니다.');
    }

    result.name = name;

    //닉네임만 변경
    if (!file) {
      result.avatar = user.avatar;
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
        result.avatar = path;
      } catch {
        throw new InternalServerErrorException(
          '새로운 프로필 사진 업로드에 실패하였습니다.'
        );
      }
    }
    try {
      await this.userRepository.update(id, result);
    } catch {
      throw new InternalServerErrorException(
        '사용자 정보 갱신에 실패하였습니다.'
      );
    }

    try {
      result.avatar = await this.storageService.getImageUrl(result.avatar);
    } catch {
      throw new InternalServerErrorException(
        '사용자 프로필 사진을 찾을 수 없습니다.'
      );
    }

    return result;
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
