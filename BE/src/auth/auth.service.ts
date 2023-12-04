import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { HttpService } from '@nestjs/axios';
import * as jwt from 'jsonwebtoken';
import { UsersService } from 'src/users/users.service';
import { isArray } from 'class-validator';
import { CreateAuthRequestDto } from './dto/create-auth-request.dto';
import { CreateAuthRequestForDevDto } from './dto/create-auth-request-for-dev.dto';
import { firstValueFrom } from 'rxjs';
import { JwksClient } from 'jwks-rsa';

@Injectable()
export class AuthService {
  constructor(
    private readonly jwtService: JwtService,
    private readonly httpService: HttpService,
    private readonly usersService: UsersService
  ) {}

  async refresh(request) {
    const [type, token] = request.headers.authorization?.split(' ') ?? [];
    if (type !== 'Bearer') {
      throw new BadRequestException('JWT가 아닙니다.');
    } else if (!token) {
      throw new BadRequestException('토큰이 존재하지 않습니다.');
    }
    try {
      const payload = await this.jwtService.verifyAsync(token, {
        secret: process.env.JWT_SECRET_REFRESH,
      });
      const id = payload.id;
      console.log(id);
      const user = await this.usersService.findUserById(id);
      if (!user) {
        throw new UnauthorizedException('회원 정보가 존재하지 않습니다.');
      }
      console.log('user exists');
      const accessToken = await this.jwtService.signAsync({ id });
      return { accessToken };
    } catch {
      throw new UnauthorizedException('올바르지 않은 토큰입니다.');
    }
  }

  async login(request, createAuthDto: CreateAuthRequestDto) {
    const [type, token] = request.headers.authorization?.split(' ') ?? [];
    if (type === 'Bearer' && token) {
      throw new BadRequestException('JWT가 이미 존재합니다.');
    }
    const idToken = createAuthDto.idToken;
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

    let decodedPayload;
    if (typeof decodedResult === 'string') {
      decodedPayload = JSON.parse(decodedResult);
    } else {
      decodedPayload = decodedResult;
    }

    if (
      decodedPayload.iss !== 'https://appleid.apple.com' ||
      decodedPayload.aud !== process.env.CLIENT_ID
    ) {
      throw new UnauthorizedException(
        'identity 토큰 내의 정보가 올바르지 않습니다.'
      );
    }

    const appleId = decodedPayload.sub;
    let user = await this.usersService.getUserInfoByResourceId(appleId);

    if (isArray(user)) {
      throw new InternalServerErrorException();
    }

    if (!user) {
      user = await this.usersService.createUser(appleId);
      if (!user) {
        throw new InternalServerErrorException();
      }
    }

    const payload = { id: user.id };
    return {
      accessToken: await this.jwtService.signAsync(payload),
      refreshToken: await this.jwtService.signAsync(payload, {
        expiresIn: '30d',
        secret: process.env.JWT_SECRET_REFRESH,
      }),
    };
  }

  async loginForDev(createAuthForDevDto: CreateAuthRequestForDevDto) {
    const id = createAuthForDevDto.id;
    const user = await this.usersService.findUserById(id);
    console.log(user);

    if (user) {
      const payload = { id };
      return {
        accessToken: await this.jwtService.signAsync(payload),
        refreshToken: await this.jwtService.signAsync(payload, {
          expiresIn: '30d',
          secret: process.env.JWT_SECRET_REFRESH,
        }),
      };
    } else {
      const payload = { id };
      console.log(await this.jwtService.signAsync(payload));
    }

    throw new BadRequestException(
      '회원 정보가 존재하지 않습니다. ' +
        '개발용 로그인 API에서는 회원가입이 불가능합니다. ' +
        '개발용 회원 생성은 백엔드 팀원에게 문의해주세요.'
    );
  }

  clientSecretGenerator(clientId) {
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
    console.log(header);
    console.log(payload);

    //!!!추후 삭제 및 수정 필요!!!!
    const key = '';

    return jwt.sign(payload, key, {
      algorithm: 'ES256',
      header,
    });
    //!!!추후 삭제 및 수정 필요!!!!
  }

  async withdrawal(request, deleteAuthDto) {
    //클라이언트 측에서 다시 apple에 로그인 요청을 보내고 identity token과 authorization code를 함께 넘겨준다.

    const idToken = deleteAuthDto.idToken;
    const authorizationCode = deleteAuthDto.authorizationCode;

    const kid = jwt.decode(idToken, {
      complete: true,
    }).header.kid;

    console.log('kid');
    console.log(kid);
    console.log();

    const client = new JwksClient({
      jwksUri: 'https://appleid.apple.com/auth/keys',
    });

    const key = await client.getSigningKey(kid);
    const verifyingKey = key.getPublicKey();

    console.log('verifying key');
    console.log(verifyingKey);
    console.log();

    const decodedResult = jwt.verify(idToken, verifyingKey, {
      algorithms: ['RS256'],
    });

    console.log('decoded result');
    console.log(decodedResult);
    console.log();

    let decodedPayload;
    if (typeof decodedResult === 'string') {
      decodedPayload = JSON.parse(decodedResult);
    } else {
      decodedPayload = decodedResult;
    }

    console.log('decoded payload');
    console.log(decodedPayload);
    console.log();

    if (
      decodedPayload.iss !== 'https://appleid.apple.com' ||
      decodedPayload.aud !== process.env.CLIENT_ID
    ) {
      throw new UnauthorizedException(
        'identity 토큰 내의 정보가 올바르지 않습니다.'
      );
    }

    const clientId = decodedPayload.aud;
    const clientSecret = this.clientSecretGenerator(clientId);
    const payload = {
      code: authorizationCode,
      client_id: clientId,
      grant_type: 'authorization_code',
      client_secret: clientSecret,
    };
    console.log('payload');
    console.log(payload);
    console.log();

    const tokenRequestResult = await firstValueFrom(
      this.httpService.post('https://appleid.apple.com/auth/token', payload, {
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      })
    );

    const info = tokenRequestResult.data;
    console.log('토큰 요청 결과');
    console.log(info);
    console.log();

    const token = info.refresh_token;
    const revoke = {
      client_id: clientId,
      client_secret: clientSecret,
      token,
    };

    const revokeRequetResult = await firstValueFrom(
      this.httpService.post('https://appleid.apple.com/auth/revoke', revoke, {
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      })
    );
    console.log('revoke 결과');
    console.log(revokeRequetResult);
    console.log();
    console.log('상태코드');
    console.log(revokeRequetResult.status);
    console.log();
    if (revokeRequetResult.status === 200) {
      const appleId = decodedPayload;
      const revokeUser =
        await this.usersService.getUserInfoByResourceId(appleId);
      const id = revokeUser.id;
      this.usersService.deleteUser(id);
    }
  }
}
