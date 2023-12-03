import { IsOptional, IsString, MaxLength, MinLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class UpdateUserDto {
  @IsString()
  @MinLength(1)
  @MaxLength(14)
  @ApiProperty({ example: '레몬', description: '변경할 사용자 이름' })
  name: string;

  @IsOptional()
  @ApiProperty({
    required: false,
    type: 'file',
    description: '프로필 사진으로 등록하려는 이미지',
  })
  image: Express.Multer.File;
}
