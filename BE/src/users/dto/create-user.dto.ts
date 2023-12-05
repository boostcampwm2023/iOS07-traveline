import { ApiProperty } from '@nestjs/swagger';
import {
  IsArray,
  IsEmail,
  IsIP,
  IsNumber,
  IsString,
  MaxLength,
  MinLength,
} from 'class-validator';

export class CreateUserDto {
  @IsString()
  @MinLength(1)
  @MaxLength(14)
  @ApiProperty()
  name: string;

  @IsString()
  @ApiProperty()
  resourceId: string;

  @IsNumber()
  @ApiProperty()
  socialType: number;

  @ApiProperty()
  @IsEmail()
  @MinLength(4)
  @MaxLength(35)
  email: string;

  @ApiProperty()
  @IsArray()
  @IsIP(4, { each: true })
  allowedIp: string[];
}
