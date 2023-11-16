import {
  IsString,
  MinLength,
  MaxLength,
  IsOptional,
  IsNumber,
  IsDate,
} from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateTimelineDto {
  @IsString()
  @MinLength(1)
  @MaxLength(14)
  @ApiProperty()
  title: string;

  @IsNumber()
  @ApiProperty()
  day: number;

  @IsString()
  @MinLength(1)
  @MaxLength(500)
  @ApiProperty()
  description: string;

  @IsOptional()
  @IsString()
  @ApiProperty()
  image: string;

  @IsOptional()
  @IsNumber()
  @ApiProperty()
  coordX: number;

  @IsOptional()
  @IsNumber()
  @ApiProperty()
  coordY: number;

  @IsOptional()
  @IsDate()
  @ApiProperty()
  date: Date;

  @IsOptional()
  @IsString()
  @ApiProperty()
  place: string;

  @IsOptional()
  @IsDate()
  @ApiProperty()
  time: Date;
}
