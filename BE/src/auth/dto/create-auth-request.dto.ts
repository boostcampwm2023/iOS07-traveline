import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';

export class CreateAuthRequestDto {
  @ApiProperty()
  @IsString()
  idToken: string;
}
