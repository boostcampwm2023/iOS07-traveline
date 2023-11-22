import { Controller, Post, Body, Param, Delete } from '@nestjs/common';
import { AuthService } from './auth.service';
import { UsersService } from 'src/users/users.service';
import { ApiOkResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { CreateAuthDto } from './dto/create-auth.dto';

@Controller('auth')
@ApiTags('Auth API')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly usersService: UsersService
  ) {}

  @Post('login')
  @ApiOperation({
    summary: '로그인 또는 회원가입 API',
    description:
      'body로 전달받은 회원 정보를 확인하고 존재하는 회원이면 로그인을, 존재하지 않는 회원이면 회원가입을 진행한다.',
  })
  @ApiOkResponse({ description: 'OK' })
  login(@Body() createAuthDto: CreateAuthDto) {
    return this.authService.login(createAuthDto.id);
  }

  @Post('logout')
  @ApiOperation({
    summary: '로그아웃 API',
    description: 'body로 전달받은 회원 정보를 확인하고 로그아웃을 진행한다.',
  })
  @ApiOkResponse({ description: 'OK' })
  logout(@Body() createAuthDto: CreateAuthDto) {
    //return this.authService.logout(createAuthDto);
  }

  @Delete('withdrawal')
  @ApiOperation({
    summary: '탈퇴 API',
    description: 'body로 전달받은 회원 정보를 확인하고 회원 정보를 삭제한다.',
  })
  @ApiOkResponse({ description: 'OK' })
  remove(@Param('id') id: string) {
    return this.authService.remove(+id);
  }
}
