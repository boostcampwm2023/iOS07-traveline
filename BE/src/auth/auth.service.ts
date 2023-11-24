import { Injectable, UnauthorizedException } from '@nestjs/common';
import { CreateAuthDto } from './dto/create-auth.dto';
import { UserInfoDto } from '../users/dto/user-info.dto';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AuthService {
  constructor(private readonly jwtService: JwtService) {}

  async login(id: string) {
    const isValidUser = this.validate(id);
    if (!isValidUser) {
      throw new UnauthorizedException();
    }
    const payload = { id };
    return {
      access_token: await this.jwtService.signAsync(payload),
    };
  }

  validate(id: string) {
    //임시로 작성해둔 함수입니다.
    if (id) {
      return true;
    }
    return false;
  }

  create(createAuthDto: CreateAuthDto) {
    return 'This action adds a new auth';
  }

  findAll() {
    return `This action returns all auth`;
  }

  findOne(id: number) {
    return `This action returns a #${id} auth`;
  }

  update(id: number, updateUserDto: UserInfoDto) {
    return `This action updates a #${id} auth`;
  }

  remove(id: number) {
    return `This action removes a #${id} auth`;
  }
}
