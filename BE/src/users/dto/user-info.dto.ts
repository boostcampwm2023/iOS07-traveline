import { ApiProperty } from '@nestjs/swagger';
import { IsOptional, IsString, MaxLength, MinLength } from 'class-validator';

export class UserInfoDto {
  @IsOptional()
  @IsString()
  @MinLength(1)
  @MaxLength(14)
  @ApiProperty()
  name: string;

  @IsString()
  @IsOptional()
  @ApiProperty()
  avatar: string;
}