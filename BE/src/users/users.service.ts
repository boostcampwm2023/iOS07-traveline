import { BadRequestException, Injectable } from '@nestjs/common';
import { UserInfoDto } from './dto/user-info.dto';
import { StorageService } from 'src/storage/storage.service';
import { UserRepository } from './users.repository';
import { CheckDuplicatedNameResponseDto } from './dto/check-duplicated-name-response.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { UpdateUserIpDto } from './dto/update-user-ip.dto';
import { BlockRepository } from './block.repository';

@Injectable()
export class UsersService {
  constructor(
    private userRepository: UserRepository,
    private blockRepository: BlockRepository,
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

  async createUser(resourceId: string, email: string, ipAddress: string) {
    let name = this.nameGenerator();
    while (true) {
      const user = await this.userRepository.findByName(name);
      if (!user) {
        break;
      }
      name = this.nameGenerator();
    }
    const socialType = 1;
    const createUserDto = {
      name,
      resourceId,
      socialType,
      email,
      allowedIp: [ipAddress],
    };
    return this.userRepository.save(createUserDto);
  }

  async deleteUser(id: string) {
    const deleteResult = await this.userRepository.delete(id);
    if (deleteResult.affected == 0) {
      throw new BadRequestException('존재하지 않는 사용자 입니다.');
    }
    return true;
  }

  async findUserById(id: string) {
    return this.userRepository.findById(id);
  }

  async getUserInfoById(id: string) {
    const user = await this.userRepository.findById(id);
    const avatarPath = user.avatar;
    if (user.avatar !== null) {
      user.avatar = await this.storageService.getImageUrl(avatarPath);
    }
    return { name: user.name, avatar: user.avatar, avatarPath };
  }

  async getUserInfoByResourceId(resourceId: string) {
    return this.userRepository.findByResourceId(resourceId);
  }

  async updateUserInfo(
    id: string,
    updateUserDto: UpdateUserDto,
    newAvatarFile: Express.Multer.File
  ): Promise<UserInfoDto> {
    const name = updateUserDto.name;
    const originalUserInfo = await this.userRepository.findById(id);

    let updatedUserInfo = {};
    if (originalUserInfo.name !== name) {
      updatedUserInfo = { ...updatedUserInfo, name };
    }

    if (originalUserInfo.avatar !== null) {
      await this.storageService.delete(originalUserInfo.avatar);
      updatedUserInfo = { ...updatedUserInfo, avatar: null };
    }

    if (newAvatarFile) {
      const uploadResult = await this.storageService.upload(
        `${id}/`,
        newAvatarFile
      );
      const avatar = uploadResult.path;
      updatedUserInfo = { ...updatedUserInfo, avatar };
    }

    await this.userRepository.update(id, updatedUserInfo);
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

  async updateUserIp(id: string, updateUserIpDto: UpdateUserIpDto) {
    return this.userRepository.update(id, updateUserIpDto);
  }

  async blockUser(blocker: string, blocked: string) {
    if (blocker === blocked) {
      throw new BadRequestException('자기 자신을 차단할 수 없습니다.');
    }

    const blockedUser = await this.userRepository.findById(blocked);
    if (!blockedUser) {
      throw new BadRequestException('존재하지 않는 회원을 차단할 수 없습니다.');
    }

    const block = await this.blockRepository.findByBlockerAndBlocked(
      blocker,
      blocked
    );
    if (block) {
      throw new BadRequestException('이미 차단한 회원입니다.');
    }

    const blockerUser = await this.userRepository.findById(blocker);
    return this.blockRepository.save(blockerUser, blockedUser);
  }
}
