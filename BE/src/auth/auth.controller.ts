import {
  Controller,
  Post,
  Body,
  Delete,
  Get,
  Req,
  UseGuards,
  Param,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { ApiOkResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { CreateAuthRequestForDevDto } from './dto/create-auth-request-for-dev.dto';
import { AuthGuard } from './auth.guard';
import { login, refresh, withdrawal } from './auth.swagger';
import { SocialLoginRequestDto } from 'src/socialLogin/dto/social-login-request.dto';
import { SocialWithdrawRequestDto } from 'src/socialLogin/dto/social-withdraw-request.dto';

@Controller('auth')
@ApiTags('Auth API')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Get('refresh')
  @ApiOperation({
    summary: 'access token 재발급 API',
    description: 'refresh token을 이용해 access token을 재발급받는 API 입니다.',
  })
  @ApiOkResponse({ description: 'OK', schema: { example: refresh } })
  refresh(@Req() request) {
    const headerMap: Map<string, string> = this.makeHeaderMap(request);
    return this.authService.refresh(headerMap);
  }

  @Post('login/:social')
  @ApiOperation({
    summary: '로그인 또는 회원가입 API',
    description:
      '전달받은 idToken 내의 회원 정보를 확인하고 존재하는 회원이면 로그인을, 존재하지 않는 회원이면 회원가입을 진행합니다.',
  })
  @ApiOkResponse({ description: 'OK', schema: { example: login } })
  socialLogin(
    @Req() request,
    @Param('social') social: string,
    @Body() socialLoginRequestDto: SocialLoginRequestDto
  ) {
    const headerMap: Map<string, string> = this.makeHeaderMap(request);
    return this.authService.login(social, headerMap, socialLoginRequestDto);
  }

  @Post('login/dev')
  @ApiOperation({
    summary: '개발용 로그인 API',
    description:
      '전달받은 회원 id를 확인하고 존재하는 회원이면 로그인을 진행합니다.' +
      '개발 테스트용 API에서는 회원가입이 불가합니다.' +
      '회원 생성이 필요한 경우 백엔드 팀원에게 요청해주세요.',
  })
  @ApiOkResponse({ description: 'OK', schema: { example: login } })
  loginForDev(@Body() createAuthForDevDto: CreateAuthRequestForDevDto) {
    return this.authService.loginForDev(createAuthForDevDto);
  }

  @UseGuards(AuthGuard)
  @Delete('withdraw/:social')
  @ApiOperation({
    summary: '탈퇴 API',
    description:
      '전달받은 idToken과 authorizationCode를 이용해 탈퇴를 진행합니다.',
  })
  @ApiOkResponse({
    description: 'OK',
    schema: { example: withdrawal },
  })
  socialWithdraw(
    @Req() request,
    @Param('social') social: string,
    @Body() socialWithdrawRequestDto: SocialWithdrawRequestDto
  ) {
    const userId = request['user'].id;
    return this.authService.withdraw(social, userId, socialWithdrawRequestDto);
  }

  private makeHeaderMap(request): Map<string, string> {
    return Object.keys(request.headers).reduce((m, key) => {
      m.set(key, request.headers[key]);
      return m;
    }, new Map<string, string>());
  }

  // @UseGuards(AuthGuard)
  // @Delete('withdrawal')
  // @ApiOperation({
  //   summary: '탈퇴 API',
  //   description:
  //     '전달받은 idToken과 authorizationCode를 이용해 탈퇴를 진행합니다.',
  // })
  // @ApiOkResponse({
  //   description: 'OK',
  //   schema: { example: withdrawal },
  // })
  // withdrawal(
  //   @Req() request,
  //   @Body() socialWithdrawRequestDto: SocialWithdrawRequestDto
  // ) {
  //   const userId = request['user'].id;
  //   return this.authService.withdrawalApple(
  //     'apple',
  //     userId,
  //     socialWithdrawRequestDto
  //   );
  // }

  // 추후 수정 예정
  // @Get('ip')
  // async manageIp(
  //   @Res() response,
  //   @Query('id') id: string,
  //   @Query('ip') ip: string,
  //   @Query('allow', ParseBoolPipe) allow: boolean
  // ) {
  //   if (await this.authService.manageIp(id, ip, allow)) {
  //     response.redirect('/ip-process-result');
  //   }
  // }
}
