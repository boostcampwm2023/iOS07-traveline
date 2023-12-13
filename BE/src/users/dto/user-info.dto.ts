import { ApiProperty } from '@nestjs/swagger';
import { IsString, MaxLength, MinLength } from 'class-validator';

export class UserInfoDto {
  @IsString()
  @MinLength(1)
  @MaxLength(14)
  @ApiProperty()
  name: string;

  @IsString()
  @ApiProperty({ nullable: true })
  avatar: string;

  @IsString()
  @ApiProperty({ nullable: true })
  avatarPath: string;
}
