import { SocialWithdrawRequestDto } from './dto/social-withdraw-request.dto';
import { SocialLoginStrategy } from './social-login-strategy.interface';
import { SocialLoginRequestDto } from './dto/social-login-request.dto';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import * as jwt from 'jsonwebtoken';
import { firstValueFrom } from 'rxjs';

@Injectable()
export class KakaoLoginStrategy implements SocialLoginStrategy {
  constructor(private readonly httpService: HttpService) {}

  async login(
    socialLoginRequestDto: SocialLoginRequestDto
  ): Promise<{ resourceId: string; email: string }> {
    try {
      const { idToken } = socialLoginRequestDto;
      const { sub, email } = jwt.decode(idToken) as {
        sub: string;
        email: string;
      };
      return { resourceId: sub, email };
    } catch (error) {
      throw new UnauthorizedException('유효하지 않은 형식의 토큰입니다.');
    }
  }

  async withdraw(
    resourceId: string,
    socialWithdrawRequestDto: SocialWithdrawRequestDto
  ): Promise<void> {
    const payload = {
      target_id_type: 'user_id',
      target_id: resourceId,
    };
    const headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      Authorization: `KakaoAK ${process.env.KAKAO_SERVICE_APP_ADMIN_KEY}`,
    };

    try {
      await firstValueFrom(
        this.httpService.post(
          'https://kapi.kakao.com/v1/user/unlink',
          payload,
          {
            headers: headers,
          }
        )
      );
    } catch (error) {
      throw new Error(error.msg);
    }
  }
}
