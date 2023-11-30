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
    console.log('token');
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

  getPublicKey(n: string, e: string) {
    // 비대칭 암호화 공개키 생성을 위한 함수
    const bufferN = Buffer.from(n, 'hex');
    const bufferE = Buffer.from(e, 'hex');

    const publicKey = {
      type: 'rsa',
      format: 'der',
      key: Buffer.concat([
        Buffer.from([
          0x30, 0x81, 0x9f, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
          0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x81, 0x8d, 0x00,
        ]),
        bufferN,
        Buffer.from([0x02, 0x03]),
        bufferE,
      ]),
    };
    return publicKey;
  }

  async login(request, createAuthDto: CreateAuthRequestDto) {
    const [type, token] = request.headers.authorization?.split(' ') ?? [];
    if (type === 'Bearer' && token) {
      throw new BadRequestException('JWT가 이미 존재합니다.');
    }
    const idToken = createAuthDto.idToken;
    const decodedIdTokenHeader = jwt.decode(idToken, {
      complete: true,
    }).header;

    const getResult = await firstValueFrom(
      this.httpService.get('https://appleid.apple.com/auth/keys')
    );
    const publicKeyArr = getResult.data.keys;
    console.log(publicKeyArr);

    let publicKey;
    for (let i = 0; i < publicKeyArr.length; i++) {
      if (
        publicKeyArr[i].kid == decodedIdTokenHeader.kid &&
        publicKeyArr[i].alg == decodedIdTokenHeader.alg
      ) {
        publicKey = this.getPublicKey(publicKeyArr[i].n, publicKeyArr[i].e);
        break;
      }
    }

    if (!publicKey) {
      throw new InternalServerErrorException();
    }

    const decodedResult = jwt.verify(idToken, publicKey, {
      algorithms: ['RS256'],
    });
    console.log(decodedResult);

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
    const user = this.usersService.findUserById(id);

    if (user) {
      const payload = { id };
      return {
        accessToken: await this.jwtService.signAsync(payload),
        refreshToken: await this.jwtService.signAsync(payload, {
          expiresIn: '30d',
          secret: process.env.JWT_SECRET_REFRESH,
        }),
      };
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
    return jwt.sign(payload, process.env.SECRET_FOR_APPLE, {
      algorithm: 'ES256',
      header,
    });
  }

  async withdrawal(request, deleteAuthDto) {
    //클라이언트 측에서 다시 apple에 로그인 요청을 보내고 identity token과 authorization code를 함께 넘겨준다.

    const idToken = deleteAuthDto.idToken;
    const authorizationCode = deleteAuthDto.authorizationCode;

    const decodedIdTokenHeader = jwt.decode(idToken, {
      complete: true,
    }).header;

    const getResult = await firstValueFrom(
      this.httpService.get('https://appleid.apple.com/auth/keys')
    );
    const publicKeyArr = getResult.data.keys;
    console.log(publicKeyArr);

    let publicKey;
    for (let i = 0; i < publicKeyArr.length; i++) {
      if (
        publicKeyArr[i].kid == decodedIdTokenHeader.kid &&
        publicKeyArr[i].alg == decodedIdTokenHeader.alg
      ) {
        publicKey = this.getPublicKey(publicKeyArr[i].n, publicKeyArr[i].e);
        break;
      }
    }

    if (!publicKey) {
      throw new InternalServerErrorException();
    }

    const decodedResult = jwt.verify(idToken, publicKey, {
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

    const clientId = decodedPayload.aud;
    const clientSecret = this.clientSecretGenerator(clientId);
    const payload = {
      code: authorizationCode,
      client_id: clientId,
      grant_type: 'authorization_code',
      client_secret: clientSecret,
    };

    const postResult = await firstValueFrom(
      this.httpService.post('https://appleid.apple.com/auth/token', payload)
    );

    const info = postResult.data;
    const token = info.refresh_token;
    const revoke = { client_id: clientId, client_secret: clientSecret, token };

    const revokeResult = await firstValueFrom(
      this.httpService.post('https://appleid.apple.com/auth/revoke', revoke)
    );
    console.log(revokeResult.data);
  }
}
