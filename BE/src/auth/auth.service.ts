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
import { CreateAuthRequestDto } from './dto/create-auth-request.dto';
import { CreateAuthRequestForDevDto } from './dto/create-auth-request-for-dev.dto';
import { firstValueFrom } from 'rxjs';
import { JwksClient } from 'jwks-rsa';
import { EmailService } from 'src/email/email.service';

@Injectable()
export class AuthService {
  constructor(
    private readonly jwtService: JwtService,
    private readonly httpService: HttpService,
    private readonly usersService: UsersService,
    private readonly emilService: EmailService
  ) {}

  async refresh(request) {
    const ipAddress = request.headers['x-real-ip'];
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
      const user = await this.usersService.findUserById(id);
      if (!user) {
        throw new UnauthorizedException('회원 정보가 존재하지 않습니다.');
      }
      let bannedIpArray;
      if (user.bannedIp === null) {
        bannedIpArray = [];
      } else {
        bannedIpArray = user.bannedIp;
      }
      if (ipAddress in bannedIpArray) {
        throw new UnauthorizedException(
          '비정상적인 접근 시도로 차단된 IP입니다.'
        );
      }
      const accessToken = await this.jwtService.signAsync({ id });
      return { accessToken };
    } catch (error) {
      if (error instanceof UnauthorizedException) {
        throw error;
      } else {
        throw new UnauthorizedException('다시 로그인해주세요.');
      }
    }
  }

  async decodeIdToken(idToken) {
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

  async login(request, createAuthDto: CreateAuthRequestDto) {
    const ipAddress = request.headers['x-real-ip'];
    const [type, token] = request.headers.authorization?.split(' ') ?? [];
    if (type === 'Bearer' && token) {
      throw new BadRequestException('JWT가 이미 존재합니다.');
    }
    const idToken = createAuthDto.idToken;

    const appleId = (await this.decodeIdToken(idToken)).sub;

    let user = await this.usersService.getUserInfoByResourceId(appleId);

    if (!user) {
      const email = createAuthDto.email;
      if (!email) {
        throw new BadRequestException('이메일 정보가 누락되어있습니다.');
      }
      user = await this.usersService.createUser(appleId, email, ipAddress);
      if (!user) {
        throw new InternalServerErrorException();
      }
    } else {
      const allowedIpArray = user.allowedIp;
      let bannedIpArray;
      if (user.bannedIp === null) {
        bannedIpArray = [];
      } else {
        bannedIpArray = user.bannedIp;
      }
      if (ipAddress in bannedIpArray) {
        throw new UnauthorizedException(
          '접속하신 IP에서의 계정 접근이 차단되어있습니다.'
        );
      }
      if (!(ipAddress in allowedIpArray)) {
        const html = await this.emilService.template('email.ejs', {
          username: user.name,
          newIp: ipAddress,
          id: user.id,
        });

        await this.emilService.sendEmail(
          user.email,
          '[traveline] 새로운 환경 로그인 안내',
          html
        );
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

    if (user) {
      const payload = { id };
      try {
        const html = await this.emilService.template('email.ejs', {
          username: user.name,
          newIp: '아 이 피',
          id: user.id,
        });

        await this.emilService.sendEmail(
          user.email,
          '[traveline] 새로운 환경 로그인 안내',
          html
        );

        return {
          accessToken: await this.jwtService.signAsync(payload),
          refreshToken: await this.jwtService.signAsync(payload, {
            expiresIn: '30d',
            secret: process.env.JWT_SECRET_REFRESH,
          }),
        };
      } catch (e) {
        console.log(e);
      }
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

  async withdrawal(request, deleteAuthDto) {
    const revokeUser = await this.usersService.findUserById(request['user'].id);

    const idToken = deleteAuthDto.idToken;
    const authorizationCode = deleteAuthDto.authorizationCode;

    const decodedIdToken = await this.decodeIdToken(idToken);

    if (decodedIdToken.sub !== revokeUser.resourceId) {
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

    const tokenRequestResult = await firstValueFrom(
      this.httpService.post('https://appleid.apple.com/auth/token', payload, {
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      })
    );

    const info = tokenRequestResult.data;
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

    if (revokeRequetResult.status === 200) {
      await this.usersService.deleteUser(revokeUser.id);
      return { revoke: true };
    }
    return { revoke: false };
  }

  async manageIp(id, ip, allow) {
    const user = await this.usersService.findUserById(id);

    const allowedIp = user.allowedIp;
    const bannedIp = user.bannedIp;

    if (allow) {
      allowedIp.push(ip);
    } else {
      bannedIp.push(ip);
    }
    const result = await this.usersService.updateUserIp(id, {
      allowedIp,
      bannedIp,
    });

    if (result.affected !== 1) {
      throw new InternalServerErrorException();
    }

    return true;
  }
}
