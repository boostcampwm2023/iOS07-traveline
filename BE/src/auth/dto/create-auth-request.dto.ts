import { ApiProperty } from '@nestjs/swagger';
import {
  IsEmail,
  IsOptional,
  IsString,
  MaxLength,
  MinLength,
} from 'class-validator';

export class CreateAuthRequestDto {
  @ApiProperty()
  @IsString()
  idToken: string;

  @ApiProperty({
    required: false,
  })
  @IsEmail()
  @MinLength(4)
  @MaxLength(35)
  @IsOptional()
  email?: string;
}
