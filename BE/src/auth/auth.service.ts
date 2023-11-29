import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { HttpService } from '@nestjs/axios';
import * as jwt from 'jsonwebtoken';
import { UsersService } from 'src/users/users.service';
import { isArray } from 'class-validator';
import { CreateAuthRequestDto } from './dto/create-auth-request.dto';

@Injectable()
export class AuthService {
  constructor(
    private readonly jwtService: JwtService,
    private readonly httpService: HttpService,
    private readonly usersService: UsersService
  ) {}

  async refresh(request) {}

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

  async login(createAuthDto: CreateAuthRequestDto) {
    //로그아웃 상태인지 확인 필요 (로그인 상태일 경우 redirect)
    const idToken = createAuthDto.idToken;
    const decodedIdTokenHeader = jwt.decode(idToken, {
      complete: true,
    }).header;

    const res = await this.httpService.get(
      'https://appleid.apple.com/auth/keys'
    );
    const publicKeyArr = JSON.parse(res.toString()).keys;

    let publicKey;
    for (let i = 0; i < publicKeyArr.length; i++) {
      if (
        publicKeyArr.kid == decodedIdTokenHeader.kid &&
        publicKeyArr.alg == decodedIdTokenHeader.alg
      ) {
        publicKey = this.getPublicKey(publicKeyArr[i].n, publicKeyArr[i].e);
        break;
      }
    }

    const decodedPayload = await this.jwtService.verifyAsync(idToken, {
      secret: publicKey,
    });

    console.log(decodedPayload);
    //검증 로직 필요 - 테스트 해서 나오는 값 보고 검증 진행 예정

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

    const accessPayload = { id: user.id, type: 'access' };
    const refreshPayload = { id: user.id, type: 'refresh' };
    return {
      accessToken: await this.jwtService.signAsync(accessPayload),
      refreshToken: await this.jwtService.signAsync(refreshPayload, {
        expiresIn: '30d',
      }),
    };
  }

  withdrawal() {}
}
