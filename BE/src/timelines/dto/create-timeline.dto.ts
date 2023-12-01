import {
  IsString,
  MinLength,
  MaxLength,
  IsOptional,
  IsNumber,
  Matches,
  IsISO8601,
  IsUUID,
} from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { Transform } from 'class-transformer';

export class CreateTimelineDto {
  @ApiProperty({ example: '서울역에서 출발~', maxLength: 14, minLength: 1 })
  @IsString()
  @MinLength(1)
  @MaxLength(14)
  title: string;

  @ApiProperty({ example: 1, description: 'Day1에서의 1' })
  @Transform(({ value }) => parseInt(value))
  @IsNumber()
  day: number;

  @ApiProperty({
    example:
      '서울역에 일찍 도착해서, 편의점에서 간식거리를 사먹으며 기다렸어요!',
    maxLength: 500,
    minLength: 1,
  })
  @IsString()
  @MinLength(1)
  @MaxLength(500)
  description: string;

  @ApiProperty({
    required: false,
    type: 'file',
    description: '업로드하는 사진',
  })
  @IsOptional()
  image: Express.Multer.File;

  @ApiProperty({
    required: false,
    type: 'double',
    example: 126.970606917394,
    description: '장소의 X 좌표',
  })
  @IsOptional()
  @Transform(({ value }) => parseFloat(value))
  @IsNumber()
  coordX: number;

  @ApiProperty({
    required: false,
    type: 'double',
    example: 37.5546788388674,
    description: '장소의 Y 좌표',
  })
  @IsOptional()
  @Transform(({ value }) => parseFloat(value))
  @IsNumber()
  coordY: number;

  @ApiProperty({
    example: '2023-11-29',
    description: '해당 타임라인에 작성한 여행 날짜',
  })
  @IsISO8601({ strict: true })
  date: string;

  @ApiProperty({
    example: 'GS25 서울역점',
    description: '장소 이름',
    maxLength: 50,
  })
  @IsString()
  place: string;

  @ApiProperty({ example: '07:25', description: 'HH:MM 형식' })
  @IsString()
  @Matches(/^([01]\d|2[0-3]):([0-5]\d)$/, {
    message: '올바른 HH:MM 형식이어야 합니다.',
  })
  time: string;

  @ApiProperty({
    example: '22550a18-fe73-42d7-9c64-6e7da27660e7',
    description: '타임라인을 작성하고 있는 여행 게시글의 id',
  })
  @IsUUID()
  posting: string;
}
