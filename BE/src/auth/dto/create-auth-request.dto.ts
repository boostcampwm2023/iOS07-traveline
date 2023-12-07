import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsString, MaxLength, MinLength } from 'class-validator';

export class CreateAuthRequestDto {
  @ApiProperty()
  @IsString()
  idToken: string;

  @ApiProperty()
  @IsEmail()
  @MinLength(4)
  @MaxLength(35)
  email: string;
}
