import { SocialLoginRequestDto } from './dto/social-login-request.interface';
import { SocialLoginStrategy } from './social-login-strategy.interface';
import { AppleLoginRequestDto } from './dto/apple-login-request.dto';
import { UnauthorizedException } from '@nestjs/common';
import { JwksClient } from 'jwks-rsa';
import * as jwt from 'jsonwebtoken';

export class AppleLoginStrategy implements SocialLoginStrategy {
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

  withdraw(resourceId: string): Promise<void> {
    //TODO
    return;
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
}
