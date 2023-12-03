import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
} from '@nestjs/common';
import { UserInfoDto } from './dto/user-info.dto';
import { StorageService } from 'src/storage/storage.service';
import { UserRepository } from './users.repository';
import { CheckDuplicatedNameResponseDto } from './dto/check-duplicated-name-response.dto';
import { UpdateUserDto } from './dto/update-user.dto';

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

  async deleteUser(id: string) {
    const deleteResult = await this.userRepository.delete(id);
    if (deleteResult.affected == 0) {
      throw new BadRequestException('존재하지 않는 사용자 입니다.');
    } else if (deleteResult.affected > 1) {
      throw new InternalServerErrorException();
    }
    return true;
  }

  async findUserById(id: string) {
    return this.userRepository.findById(id);
  }

  async getUserInfoById(id: string): Promise<UserInfoDto> {
    const user = await this.userRepository.findById(id);
    const avatarPath = user.avatar;
    if (user.avatar !== null) {
      user.avatar = await this.storageService.getImageUrl(avatarPath);
    }
    return { name: user.name, avatar: user.avatar };
  }

  async getUserInfoByResourceId(resourceId: string) {
    return this.userRepository.findByResourceId(resourceId);
  }

  async updateUserInfo(
    id: string,
    updateUserDto: UpdateUserDto,
    newAvatarFile: Express.Multer.File
  ): Promise<UserInfoDto> {
    const nameChange = 'name' in updateUserDto;
    const deleteAvatar = updateUserDto.isAvatarDeleted;

    if (!nameChange && !newAvatarFile && !deleteAvatar) {
      throw new BadRequestException('변경 사항이 없습니다.');
    }

    if (deleteAvatar && newAvatarFile) {
      throw new BadRequestException('요구사항이 충돌합니다.');
    }

    const originalUserInfo = await this.userRepository.findById(id);

    //이름 변경이 있는 경우
    if (nameChange) {
      if (originalUserInfo.name === updateUserDto.name) {
        throw new BadRequestException('기존 닉네임과 동일합니다.');
      }
      const name = updateUserDto.name;
      await this.userRepository.update(id, { name });
    }

    //프로필을 기본이미지로 변경하고 싶어 하는 경우
    if (deleteAvatar) {
      //이미지 삭제, avatar는 null
      if (originalUserInfo.avatar !== null) {
        await this.storageService.delete(originalUserInfo.avatar);
      }
      const avatar = null;
      await this.userRepository.update(id, { avatar });
    }

    //새 프로필을 등록하고 싶어 하는 경우
    if (newAvatarFile) {
      if (originalUserInfo.avatar !== null) {
        await this.storageService.delete(originalUserInfo.avatar);
      }
      const uploadResult = await this.storageService.upload(
        `${id}/`,
        newAvatarFile
      );
      const avatar = uploadResult.path;
      await this.userRepository.update(id, { avatar });
    }

    return this.getUserInfoById(id);
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
