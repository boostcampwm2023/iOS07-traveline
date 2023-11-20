import {
  Controller,
  Get,
  Body,
  Param,
  Put,
  Query,
  UseInterceptors,
  UploadedFile,
} from '@nestjs/common';
import { User } from './entities/user.entity';
import { UsersService } from './users.service';
import { UpdateUserDto } from './dto/update-user.dto';
import { ApiOkResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { CheckDuplicatedNameResponseDto } from './dto/check-duplicated-name-response.dto';
import { FileInterceptor } from '@nestjs/platform-express';

@Controller('users')
@ApiTags('Users API')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get(':id')
  @ApiOperation({
    summary: 'id에 해당하는 User 정보 반환',
    description: 'id에 해당하는 User 정보를 반환한다.',
  })
  @ApiOkResponse({
    description: 'OK',
    type: User,
  })
  findOne(@Param('id') id: string) {
    console.log(id);
    return this.usersService.findById(id);
  }
  //테스트 완료

  @Put(':id')
  @ApiOperation({
    summary: 'id에 해당하는 User 정보 수정',
    description: 'id에 해당하는 User 정보를 수정한다.',
  })
  @ApiOkResponse({
    description: 'OK',
  })
  @UseInterceptors(FileInterceptor('file'))
  update(
    @Param('id') id: string,
    @Body() updateUserDto: UpdateUserDto,
    @UploadedFile() file: Express.Multer.File
  ) {
    return this.usersService.update(id, updateUserDto, file);
  }
  //클라이언트 측에서 프로필사진/이름 중 하나라도 변경사항이 있을 때만 요청을 보내야 한다.

  @Get('duplicate/check')
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
