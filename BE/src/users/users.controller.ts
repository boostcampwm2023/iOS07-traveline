import {
  Controller,
  Get,
  Body,
  Put,
  Query,
  UseInterceptors,
  UploadedFile,
  UseGuards,
  Req,
} from '@nestjs/common';
import { User } from './entities/user.entity';
import { UsersService } from './users.service';
import { UserInfoDto } from './dto/user-info.dto';
import { ApiOkResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { CheckDuplicatedNameResponseDto } from './dto/check-duplicated-name-response.dto';
import { FileInterceptor } from '@nestjs/platform-express';
import { AuthGuard } from 'src/auth/auth.guard';

@UseGuards(AuthGuard)
@Controller('users')
@ApiTags('Users API')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get()
  @ApiOperation({
    summary: 'id에 해당하는 User 정보 반환',
    description: 'id에 해당하는 User 정보를 반환한다.',
  })
  @ApiOkResponse({
    description: 'OK',
    type: User,
  })
  async findOne(@Req() request) {
    return this.usersService.getUserInfo(request['user'].id);
  }

  @Put()
  @ApiOperation({
    summary: 'id에 해당하는 User 정보 수정',
    description: 'id에 해당하는 User 정보를 수정한다.',
  })
  @ApiOkResponse({
    description: 'OK',
    type: UserInfoDto,
  })
  @UseInterceptors(FileInterceptor('file'))
  update(
    @Req() request,
    @Body() updateUserDto: UserInfoDto,
    @UploadedFile() file: Express.Multer.File
  ) {
    return this.usersService.updateUserInfo(
      request['user'].id,
      updateUserDto,
      file
    );
  }

  @Get('duplicate')
  @ApiOperation({
    summary: 'name 중복 검사',
    description: 'name과 동일한 이름이 DB에 존재하는지 확인한다.',
  })
  @ApiOkResponse({
    description: 'OK',
    type: CheckDuplicatedNameResponseDto,
  })
  checkDuplicatedName(@Query('name') name: string) {
    return this.usersService.checkDuplicatedName(name);
  }
}
