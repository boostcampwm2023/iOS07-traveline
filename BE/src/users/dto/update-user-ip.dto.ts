import { ApiProperty } from '@nestjs/swagger';
import { IsIP, IsString } from 'class-validator';

export class UpdateUserIpDto {
  @ApiProperty()
  @IsString({ each: true })
  @IsIP(4, { each: true })
  allowedIp: string[];

  @ApiProperty()
  @IsString({ each: true })
  @IsIP(4, { each: true })
  bannedIp: string[];
}
