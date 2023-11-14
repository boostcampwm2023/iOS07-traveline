import { ApiProperty } from '@nestjs/swagger';

export class CheckDuplicatedNameResponseDto {
  @ApiProperty({
    description: 'Indicates whether the name is duplicated or not',
  })
  readonly isDuplicated: boolean;
}
