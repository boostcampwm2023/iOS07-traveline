import { ApiProperty } from '@nestjs/swagger';

export class CheckDuplicatedNameResponseDto {
  @ApiProperty()
  readonly isDuplicated: boolean;
}
