import { Controller, Get, Body, Param, Put, Query } from '@nestjs/common';
import { User } from './entities/user.entity';
import { UsersService } from './users.service';
import { UpdateUserDto } from './dto/update-user.dto';
import { ApiOkResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { CheckDuplicatedNameResponseDto } from './dto/check-duplicated-name-response.dto';

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
    return this.usersService.findOne(id);
  }

  @Put(':id')
  @ApiOperation({
    summary: 'id에 해당하는 User 정보 수정',
    description: 'id에 해당하는 User 정보를 수정한다.',
  })
  @ApiOkResponse({
    description: 'OK',
  })
  update(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto) {
    return this.usersService.update(id, updateUserDto);
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
    this.usersService.checkDuplicatedName(name).then((result) => {
      return {
        isDuplicated: result,
      };
    });
  }
}
