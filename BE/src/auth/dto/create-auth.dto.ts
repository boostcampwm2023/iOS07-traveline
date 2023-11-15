import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, MaxLength, MinLength } from 'class-validator';

export class CreateAuthDto {
  @ApiProperty()
  @IsEmail()
  @MinLength(3)
  @MaxLength(50)
  email: string;
}
