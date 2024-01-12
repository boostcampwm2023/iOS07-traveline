import {
  Controller,
  Post,
  Body,
  Delete,
  Get,
  Req,
  UseGuards,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { ApiOkResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { CreateAuthRequestDto } from './dto/create-auth-request.dto';
import { CreateAuthRequestForDevDto } from './dto/create-auth-request-for-dev.dto';
import { DeleteAuthDto } from './dto/delete-auth.dto';
import { AuthGuard } from './auth.guard';
import { login, refresh, withdrawal } from './auth.swagger';

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
    return this.authService.refresh(request);
  }

  @Post('login')
  @ApiOperation({
    summary: '로그인 또는 회원가입 API',
    description:
      '전달받은 idToken 내의 회원 정보를 확인하고 존재하는 회원이면 로그인을, 존재하지 않는 회원이면 회원가입을 진행합니다.',
  })
  @ApiOkResponse({ description: 'OK', schema: { example: login } })
  login(@Req() request, @Body() createAuthDto: CreateAuthRequestDto) {
    return this.authService.login(request, createAuthDto);
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
  @Delete('withdrawal')
  @ApiOperation({
    summary: '탈퇴 API',
    description:
      '전달받은 idToken과 authorizationCode를 이용해 탈퇴를 진행합니다.',
  })
  @ApiOkResponse({
    description: 'OK',
    schema: { example: withdrawal },
  })
  withdrawal(@Req() request, @Body() deleteAuthDto: DeleteAuthDto) {
    return this.authService.withdrawal(request, deleteAuthDto);
  }

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
