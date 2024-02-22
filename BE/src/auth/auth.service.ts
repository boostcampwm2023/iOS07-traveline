import {
  BadRequestException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from 'src/users/users.service';
import { CreateAuthRequestForDevDto } from './dto/create-auth-request-for-dev.dto';
import { EmailService } from 'src/email/email.service';
import { SocialLoginStrategy } from 'src/socialLogin/social-login-strategy.interface';
import { KakaoLoginStrategy } from 'src/socialLogin/kakao-login-strategy';
import { User } from 'src/users/entities/user.entity';
import { SocialLoginRequestDto } from 'src/socialLogin/dto/social-login-request.dto';
import { AppleLoginStrategy } from 'src/socialLogin/apple-login-strategy';
import { SocialWithdrawRequestDto } from 'src/socialLogin/dto/social-withdraw-request.dto';

@Injectable()
export class AuthService {
  private socialLoginStrategyMap: Map<string, SocialLoginStrategy> = new Map<
    string,
    SocialLoginStrategy
  >();

  constructor(
    private readonly jwtService: JwtService,
    private readonly usersService: UsersService,
    private readonly emilService: EmailService,
    private readonly kakaoLoginStrategy: KakaoLoginStrategy,
    private readonly appleLoginStrategy: AppleLoginStrategy
  ) {
    this.socialLoginStrategyMap.set('kakao', kakaoLoginStrategy);
    this.socialLoginStrategyMap.set('apple', appleLoginStrategy);
  }

  private getLoginStrategy(social: string) {
    const socialLoginStrategy: SocialLoginStrategy =
      this.socialLoginStrategyMap.get(social);

    if (!socialLoginStrategy) {
      throw new BadRequestException('지원하지 않는 소셜 로그인 플랫폼입니다');
    }

    return socialLoginStrategy;
  }

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

  async login(
    social: string,
    headerMap: Map<string, string>,
    socialLoginRequestDto: SocialLoginRequestDto
  ) {
    const [type, token] = headerMap.get('authorization')?.split(' ') ?? [];

    if (type === 'Bearer' && token) {
      throw new BadRequestException('JWT가 이미 존재합니다.');
    }

    const socialLoginStrategy: SocialLoginStrategy =
      this.getLoginStrategy(social);
    console.log(social);
    const { resourceId, email } = await socialLoginStrategy.login(
      socialLoginRequestDto
    );
    const findUser =
      await this.usersService.getUserInfoByResourceId(resourceId);

    let user: User;
    if (findUser) {
      user = findUser;
    } else {
      const ipAddress = headerMap.get('x-real-ip');
      user = await this.usersService.createUser(resourceId, email, ipAddress);
    }

    // 추후 수정 예정
    // else {
    //   const allowedIpArray = user.allowedIp;
    //   let bannedIpArray;
    //   if (user.bannedIp === null) {
    //     bannedIpArray = [];
    //   } else {
    //     bannedIpArray = user.bannedIp;
    //   }
    //   if (ipAddress in bannedIpArray) {
    //     throw new UnauthorizedException(
    //       '접속하신 IP에서의 계정 접근이 차단되어있습니다.'
    //     );
    //   }
    //   if (!(ipAddress in allowedIpArray)) {
    //     const html = await this.emilService.template('email.ejs', {
    //       username: user.name,
    //       newIp: ipAddress,
    //       id: user.id,
    //     });

    //     await this.emilService.sendEmail(
    //       user.email,
    //       '[traveline] 새로운 환경 로그인 안내',
    //       html
    //     );
    //   }
    // }

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

      // 추후 수정 예정
      // try {
      //   const html = await this.emilService.template('email.ejs', {
      //     username: user.name,
      //     newIp: '아 이 피',
      //     id: user.id,
      //   });

      //   await this.emilService.sendEmail(
      //     user.email,
      //     '[traveline] 새로운 환경 로그인 안내',
      //     html
      //   );

      //   return {
      //     accessToken: await this.jwtService.signAsync(payload),
      //     refreshToken: await this.jwtService.signAsync(payload, {
      //       expiresIn: '30d',
      //       secret: process.env.JWT_SECRET_REFRESH,
      //     }),
      //   };
      // } catch (e) {
      //   console.log(e);
      // }

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

  async withdraw(
    social: string,
    userId: string,
    socialWithdrawRequestDto: SocialWithdrawRequestDto
  ) {
    const socialLoginStrategy: SocialLoginStrategy =
      this.getLoginStrategy(social);
    const { id, resourceId } = await this.usersService.findUserById(userId);

    try {
      await socialLoginStrategy.withdraw(resourceId, socialWithdrawRequestDto);
      await this.usersService.deleteUser(id);
      return { revoke: true };
    } catch {
      return { revoke: false };
    }
  }

  // async manageIp(id, ip, allow) {
  //   const user = await this.usersService.findUserById(id);

  //   const allowedIp = user.allowedIp;

  //   let bannedIp;
  //   if (user.bannedIp === null) {
  //     bannedIp = [];
  //   } else {
  //     bannedIp = user.bannedIp;
  //   }

  //   if (allow) {
  //     allowedIp.push(ip);
  //   } else {
  //     bannedIp.push(ip);
  //   }
  //   const result = await this.usersService.updateUserIp(id, {
  //     allowedIp,
  //     bannedIp,
  //   });

  //   if (result.affected !== 1) {
  //     throw new InternalServerErrorException();
  //   }

  //   return true;
  // }
}
