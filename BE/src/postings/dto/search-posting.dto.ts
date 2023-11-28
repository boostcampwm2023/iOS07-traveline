import { IsArray, IsIn, IsNumber, IsOptional, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import {
  budgets,
  headcounts,
  locations,
  periods,
  seasons,
  themes,
  vehicles,
  withWhos,
} from '../postings.types';

// TODO: enum 만들고 swagger에 띄우기
export class SearchPostingDto {
  @ApiProperty({ required: false })
  @IsOptional()
  @IsString()
  keyword: string = '';

  @ApiProperty({ required: false })
  @IsOptional()
  @IsString()
  sorting: string = '최신순';

  @ApiProperty({ required: false })
  @Transform(({ value }) => parseInt(value))
  @IsOptional()
  @IsNumber()
  offset: number = 0;

  @ApiProperty({ required: false })
  @Transform(({ value }) => parseInt(value))
  @IsOptional()
  @IsNumber()
  limit: number = 20;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsString()
  @IsIn(periods)
  period: string;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsString()
  @IsIn(headcounts)
  headcount: string;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsString()
  @IsIn(budgets)
  budget: string;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsString()
  @IsIn(locations)
  location: string;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsString()
  @IsIn(themes)
  theme: string;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsString()
  @IsIn(withWhos)
  withWho: string;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsString()
  @IsIn(seasons)
  season: string;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsString()
  @IsIn(vehicles)
  vehicle: string;
}
