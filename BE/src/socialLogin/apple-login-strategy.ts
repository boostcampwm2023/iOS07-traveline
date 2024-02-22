import { SocialLoginRequestDto } from './dto/social-login-request.interface';
import { SocialLoginStrategy } from './social-login-strategy.interface';
import { AppleLoginRequestDto } from './dto/apple-login-request.dto';
import { BadRequestException, UnauthorizedException } from '@nestjs/common';
import { JwksClient } from 'jwks-rsa';
import * as jwt from 'jsonwebtoken';
import { firstValueFrom } from 'rxjs';
import { HttpService } from '@nestjs/axios';
import { SocialWithdrawRequestDto } from './dto/social-withdraw-request.dto';

export class AppleLoginStrategy implements SocialLoginStrategy {
  constructor(private readonly httpService: HttpService) {}
  withdraw(resourceId: string): Promise<void> {
    throw new Error('Method not implemented.');
  }

  async login(
    socialLoginRequestDto: SocialLoginRequestDto
  ): Promise<{ resourceId: string; email: string }> {
    try {
      const { idToken, email } = socialLoginRequestDto as AppleLoginRequestDto;
      const resourceId = (await this.decodeIdToken(idToken)).sub;
      return { resourceId, email };
    } catch (error) {
      throw new UnauthorizedException('유효하지 않은 형식의 토큰입니다.');
    }
  }

  async withdraw2(
    resourceId: string,
    socialWithdrawRequestDto: SocialWithdrawRequestDto
  ): Promise<void> {
    const { idToken, authorizationCode } = socialWithdrawRequestDto;
    const decodedIdToken = await this.decodeIdToken(idToken);

    if (decodedIdToken.sub !== resourceId) {
      throw new BadRequestException(
        'identify 토큰과 access 토큰 내의 회원정보가 충돌합니다.'
      );
    }

    const clientId = decodedIdToken.aud;
    const clientSecret = this.clientSecretGenerator(clientId);
    const payload = {
      code: authorizationCode,
      client_id: clientId,
      grant_type: 'authorization_code',
      client_secret: clientSecret,
    };

    const { data } = await firstValueFrom(
      this.httpService.post('https://appleid.apple.com/auth/token', payload, {
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      })
    );

    const info = data;
    const token = info.refresh_token;
    const revoke = {
      client_id: clientId,
      client_secret: clientSecret,
      token,
    };

    const { status } = await firstValueFrom(
      this.httpService.post('https://appleid.apple.com/auth/revoke', revoke, {
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      })
    );

    if (status !== 200) {
      throw new Error('revoke 요청 실패');
    }
  }

  private async decodeIdToken(idToken) {
    const kid = jwt.decode(idToken, {
      complete: true,
    }).header.kid;

    const client = new JwksClient({
      jwksUri: 'https://appleid.apple.com/auth/keys',
    });

    const key = await client.getSigningKey(kid);
    const verifyingKey = key.getPublicKey();

    const decodedResult = jwt.verify(idToken, verifyingKey, {
      algorithms: ['RS256'],
    });

    const decodedIdToken =
      typeof decodedResult === 'string'
        ? JSON.parse(decodedResult)
        : decodedResult;

    if (
      decodedIdToken.iss !== 'https://appleid.apple.com' ||
      decodedIdToken.aud !== process.env.CLIENT_ID
    ) {
      throw new UnauthorizedException(
        'identity 토큰 내의 정보가 올바르지 않습니다.'
      );
    }
    return decodedIdToken;
  }

  private clientSecretGenerator(clientId) {
    const header = { alg: 'ES256', kid: process.env.KEY_ID };
    const iat = Math.floor(Date.now() / 1000);
    const exp = iat + 60 * 60;
    const payload = {
      iss: process.env.TEAM_ID,
      iat,
      exp,
      aud: 'https://appleid.apple.com',
      sub: clientId,
    };

    const key =
      '-----BEGIN PRIVATE KEY-----\n' +
      process.env.AUTH_KEY_LINE1 +
      '\n' +
      process.env.AUTH_KEY_LINE2 +
      '\n' +
      process.env.AUTH_KEY_LINE3 +
      '\n' +
      process.env.AUTH_KEY_LINE4 +
      '\n' +
      '-----END PRIVATE KEY-----';

    return jwt.sign(payload, key, {
      algorithm: 'ES256',
      header,
    });
  }
}
