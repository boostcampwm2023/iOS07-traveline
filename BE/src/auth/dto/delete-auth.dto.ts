import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';

export class DeleteAuthDto {
  @ApiProperty()
  @IsString()
  idToken: string;

  @ApiProperty()
  @IsString()
  authorizationCode: string;
}
