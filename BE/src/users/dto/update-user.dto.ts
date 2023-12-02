import {
  IsBoolean,
  IsOptional,
  IsString,
  MaxLength,
  MinLength,
} from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { Transform, TransformFnParams } from 'class-transformer';

export class UpdateUserDto {
  @IsOptional()
  @IsString()
  @MinLength(1)
  @MaxLength(14)
  @ApiProperty({ example: '레몬', description: '변경할 사용자 이름' })
  name: string;

  @IsBoolean()
  @Transform(({ value }: TransformFnParams) => value === 'true', {
    toClassOnly: true,
  })
  @ApiProperty({
    example: 'true',
    description: '프로필 사진 기본 이미지 설정 여부',
  })
  isAvatarDeleted: boolean;
  //deleteAvatar:boolean;

  @IsOptional()
  @ApiProperty({
    required: false,
    type: 'file',
    description: '프로필 사진으로 등록하려는 이미지',
  })
  image: Express.Multer.File;
}
