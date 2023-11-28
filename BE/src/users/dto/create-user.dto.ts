import { ApiProperty } from '@nestjs/swagger';
import { IsNumber, IsString, MaxLength, MinLength } from 'class-validator';

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
}
