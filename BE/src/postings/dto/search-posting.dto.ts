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
    example: 'bread',
  })
  @IsOptional()
  @IsString()
  keyword: string = '';

  @ApiProperty({
    required: false,
    enum: Sorting,
    default: Sorting.최신순,
    description: '게시글을 정렬하는 기준입니다.',
  })
  @IsOptional()
  @IsString()
  sorting: Sorting = Sorting.최신순;

  @ApiProperty({
    required: false,
    default: 0,
    description: '몇 번째 페이지부터 게시글을 가져올지 나타냅니다.',
  })
  @Transform(({ value }) => parseInt(value))
  @IsOptional()
  @IsNumber()
  offset: number = 0;

  @ApiProperty({
    required: false,
    default: 20,
    description: 'offset에서부터 몇 개의 게시글을 반환하는지 나타냅니다.',
  })
  @Transform(({ value }) => parseInt(value))
  @IsOptional()
  @IsNumber()
  limit: number = 20;

  @ApiProperty({ required: false, enum: Period, description: '여행기간 태그' })
  @IsOptional()
  @IsString()
  @IsIn(periods)
  period: Period;

  @ApiProperty({
    required: false,
    enum: Headcount,
    description: '인원 수 태그',
  })
  @IsOptional()
  @IsString()
  @IsIn(headcounts)
  headcount: Headcount;

  @ApiProperty({ required: false, enum: Budget, description: '여행경비 태그' })
  @IsOptional()
  @IsString()
  @IsIn(budgets)
  budget: Budget;

  @ApiProperty({
    required: false,
    enum: Location,
    description: '여행위치 태그',
  })
  @IsOptional()
  @IsString()
  @IsIn(locations)
  location: Location;

  @ApiProperty({
    required: false,
    enum: Theme,
    description: '여행테마 태그 (1개만 선택 가능)',
  })
  @IsOptional()
  @IsString()
  @IsIn(themes)
  theme: Theme;

  @ApiProperty({
    required: false,
    enum: WithWho,
    description: '누구랑 태그 (1개만 선택 가능)',
  })
  @IsOptional()
  @IsString()
  @IsIn(withWhos)
  withWho: WithWho;

  @ApiProperty({ required: false, enum: Season, description: '여행계절 태그' })
  @IsOptional()
  @IsString()
  @IsIn(seasons)
  season: Season;

  @ApiProperty({ required: false, enum: Vehicle, description: '이동수단 태그' })
  @IsOptional()
  @IsString()
  @IsIn(vehicles)
  vehicle: Vehicle;
}
