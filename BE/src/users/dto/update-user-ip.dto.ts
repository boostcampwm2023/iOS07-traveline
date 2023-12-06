import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';

export class UpdateUserIpDto {
  @ApiProperty()
  @IsString({ each: true })
  allowedIp: string[];

  @ApiProperty()
  @IsString({ each: true })
  bannedIp: string[];
}
