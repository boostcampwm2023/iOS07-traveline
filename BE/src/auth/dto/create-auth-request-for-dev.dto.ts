import { ApiProperty } from '@nestjs/swagger';
import { IsString, Length } from 'class-validator';

export class CreateAuthRequestForDevDto {
  @ApiProperty()
  @IsString()
  @Length(36)
  id: string;
}
