import { ApiProperty } from '@nestjs/swagger';
import {
  IsString,
  MinLength,
  MaxLength,
  IsDate,
  IsOptional,
} from 'class-validator';

export class CreatePostingDto {
  @ApiProperty()
  @IsString()
  @MinLength(1)
  @MaxLength(14)
  title: string;

  @ApiProperty()
  @IsDate()
  startDate: Date;

  @ApiProperty()
  @IsDate()
  endDate: Date;

  @ApiProperty()
  @IsOptional()
  @IsString()
  headcount: string;

  @ApiProperty()
  @IsString()
  budget: string;

  @ApiProperty()
  @IsString()
  location: string;

  @ApiProperty()
  @IsString({ each: true })
  theme: string[];

  @ApiProperty()
  @IsOptional()
  @IsString({ each: true })
  withWho: string[];

  @ApiProperty()
  @IsOptional()
  @IsString()
  veihicle: string;
}
