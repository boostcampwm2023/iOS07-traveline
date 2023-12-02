import { ApiProperty } from '@nestjs/swagger';

export class CheckDuplicatedNameResponseDto {
  @ApiProperty({ example: 'true', description: '닉네임의 중복 여부' })
  readonly isDuplicated: boolean;
}
