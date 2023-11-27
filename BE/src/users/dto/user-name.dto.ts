import { ApiProperty } from '@nestjs/swagger';
import { IsOptional, IsString, MaxLength, MinLength } from 'class-validator';

export class UserNameDto {
  @IsOptional()
  @IsString()
  @MinLength(1)
  @MaxLength(14)
  @ApiProperty()
  name: string;
}
