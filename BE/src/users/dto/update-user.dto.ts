import { IsString, MaxLength, MinLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class UpdateUserDto {
  @IsString()
  @MinLength(1)
  @MaxLength(14)
  @ApiProperty({ example: '레몬', description: '변경할 사용자 이름' })
  name: string;
}
