import {
  Controller,
  Post,
  Body,
  Param,
  Delete,
  Get,
  Req,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { ApiOkResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { CreateAuthRequestDto } from './dto/create-auth-request.dto';
import { CreateAuthResponseDto } from './dto/create-auth-response';
import { CreateAuthRequestForDevDto } from './dto/create-auth-request-for-dev.dto';

@Controller('auth')
@ApiTags('Auth API')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Get('refresh')
  @ApiOperation({
    summary: 'access token 발급 API',
    description: 'access token을 재발급받는 API 입니다.',
  })
  @ApiOkResponse({ description: 'OK' })
  refresh(@Req() request) {
    return this.authService.refresh(request);
  }

  @Post('login')
  @ApiOperation({
    summary: '로그인 또는 회원가입 API',
    description:
      'body로 전달받은 회원 정보를 확인하고 존재하는 회원이면 로그인을, 존재하지 않는 회원이면 회원가입을 진행합니다.',
  })
  @ApiOkResponse({ description: 'OK', type: CreateAuthResponseDto })
  login(@Req() request, @Body() createAuthDto: CreateAuthRequestDto) {
    return this.authService.login(request, createAuthDto);
  }

  @Post('login/dev')
  @ApiOperation({
    summary: '개발용 로그인 API',
    description:
      'body로 전달받은 회원 id를 확인하고 존재하는 회원이면 로그인을 진행합니다.' +
      '개발 테스트용 API에서는 회원가입이 불가합니다.' +
      '회원 생성이 필요한 경우 백엔드 팀원에게 요청해주세요.',
  })
  @ApiOkResponse({ description: 'OK', type: CreateAuthResponseDto })
  loginForDev(@Body() createAuthForDevDto: CreateAuthRequestForDevDto) {
    return this.authService.loginForDev(createAuthForDevDto);
  }

  @Delete('withdrawal')
  @ApiOperation({
    summary: '탈퇴 API',
    description: 'body로 전달받은 회원 정보를 확인하고 회원 정보를 삭제한다.',
  })
  @ApiOkResponse({ description: 'OK' })
  withdrawal(@Param('id') id: string) {
    //return this.authService.withdrawal(+id);
  }
}
