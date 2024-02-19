import { SocialLoginStrategy } from './social-login-strategy.interface';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import * as jwt from 'jsonwebtoken';
import { LoginRequestDto } from 'src/auth/dto/login-request.dto.interface';

@Injectable()
export class KakaoLoginStrategy implements SocialLoginStrategy {
  constructor(private readonly httpService: HttpService) {}

  async login(loginRequestDto: LoginRequestDto): Promise<string> {
    try {
      const { idToken } = loginRequestDto;
      const decodedIdToken = jwt.decode(idToken);
      return String(decodedIdToken.sub);
    } catch (error) {
      throw new UnauthorizedException('유효하지 않은 형식의 토큰입니다.');
    }
  }

  refresh(): void {
    // TO DO
    return;
  }

  withdraw(): void {
    // TO DO
    return;
  }
}
