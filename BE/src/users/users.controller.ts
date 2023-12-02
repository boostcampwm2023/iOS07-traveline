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
import { UsersService } from './users.service';
import {
  ApiBearerAuth,
  ApiBody,
  ApiConsumes,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { FileInterceptor } from '@nestjs/platform-express';
import { AuthGuard } from 'src/auth/auth.guard';
import { Users, getUsersDuplicate } from './users.swagger';
import { UpdateUserDto } from './dto/update-user.dto';

@UseGuards(AuthGuard)
@Controller('users')
@ApiTags('Users API')
@ApiBearerAuth('accessToken')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get()
  @ApiOperation({
    summary: 'id에 해당하는 User 정보 반환',
    description:
      'id에 해당하는 User 정보를 반환합니다. avatar는 프로필 사진의 URL에 해당하는 값입니다.',
  })
  @ApiOkResponse({
    description: 'OK',
    schema: {
      example: Users,
    },
  })
  async findOne(@Req() request) {
    return this.usersService.getUserInfoById(request['user'].id);
  }

  @Put()
  @ApiOperation({
    summary: 'id에 해당하는 User 정보 수정',
    description:
      'id에 해당하는 User 정보를 수정합니다. avatar는 새로운 프로필 사진의 URL에 해당하는 값입니다.',
  })
  @ApiOkResponse({
    description: 'OK',
    schema: {
      example: Users,
    },
  })
  @UseInterceptors(FileInterceptor('image'))
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    description:
      'json과 함께 새로운 프로필 사진을 전송해주세요. ' +
      '프로필사진 변경사항이 없을 경우 파일을 전송하지 않으시면 됩니다. ' +
      '닉네임 변경사항이 없을 경우 name 필드를 생략해주시면 됩니다.',
  })
  update(
    @Req() request,
    @Body() updateUserDto: UpdateUserDto,
    @UploadedFile() image: Express.Multer.File
  ) {
    return this.usersService.updateUserInfo(
      request['user'].id,
      updateUserDto,
      image
    );
  }

  @Get('duplicate')
  @ApiOperation({
    summary: 'name 중복 검사',
    description: 'name과 동일한 이름이 DB에 존재하는지 확인합니다.',
  })
  @ApiOkResponse({
    description: 'OK',
    schema: { example: getUsersDuplicate },
  })
  checkDuplicatedName(@Query('name') name: string) {
    return this.usersService.checkDuplicatedName(name);
  }
}
