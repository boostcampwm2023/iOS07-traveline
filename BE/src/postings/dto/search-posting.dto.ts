import { IsIn, IsNumber, IsOptional, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import {
  Budget,
  Headcount,
  Period,
  Sorting,
  Location,
  budgets,
  headcounts,
  locations,
  periods,
  seasons,
  themes,
  vehicles,
  withWhos,
  Theme,
  WithWho,
  Season,
  Vehicle,
} from '../postings.types';

export class SearchPostingDto {
  @ApiProperty({
    required: false,
    description: '검색어가 제목에 포함될 경우 검색됩니다.',
  })
  @IsOptional()
  @IsString()
  keyword: string = '';

  @ApiProperty({ required: false, enum: Sorting, default: Sorting.최신순 })
  @IsOptional()
  @IsString()
  sorting: Sorting = Sorting.최신순;

  @ApiProperty({ required: false, default: 0 })
  @Transform(({ value }) => parseInt(value))
  @IsOptional()
  @IsNumber()
  offset: number = 0;

  @ApiProperty({ required: false, default: 20 })
  @Transform(({ value }) => parseInt(value))
  @IsOptional()
  @IsNumber()
  limit: number = 20;

  @ApiProperty({ required: false, enum: Period })
  @IsOptional()
  @IsString()
  @IsIn(periods)
  period: Period;

  @ApiProperty({ required: false, enum: Headcount })
  @IsOptional()
  @IsString()
  @IsIn(headcounts)
  headcount: Headcount;

  @ApiProperty({ required: false, enum: Budget })
  @IsOptional()
  @IsString()
  @IsIn(budgets)
  budget: Budget;

  @ApiProperty({ required: false, enum: Location })
  @IsOptional()
  @IsString()
  @IsIn(locations)
  location: Location;

  @ApiProperty({ required: false, enum: Theme })
  @IsOptional()
  @IsString()
  @IsIn(themes)
  theme: Theme;

  @ApiProperty({ required: false, enum: WithWho })
  @IsOptional()
  @IsString()
  @IsIn(withWhos)
  withWho: WithWho;

  @ApiProperty({ required: false, enum: Season })
  @IsOptional()
  @IsString()
  @IsIn(seasons)
  season: Season;

  @ApiProperty({ required: false, enum: Vehicle })
  @IsOptional()
  @IsString()
  @IsIn(vehicles)
  vehicle: Vehicle;
}
