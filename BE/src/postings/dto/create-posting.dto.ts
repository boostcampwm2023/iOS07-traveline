import { ApiProperty } from '@nestjs/swagger';
import {
  IsString,
  MinLength,
  MaxLength,
  IsOptional,
  IsIn,
  ArrayMaxSize,
  IsArray,
  IsDateString,
} from 'class-validator';
import {
  BudgetType,
  HeadcountType,
  LocationType,
  ThemeType,
  VehicleType,
  WithWhoType,
  budgets,
  headcounts,
  locations,
  themes,
  vehicles,
  withWhos,
} from '../postings.types';

export class CreatePostingDto {
  @ApiProperty()
  @IsString()
  @MinLength(1)
  @MaxLength(14)
  title: string;

  @ApiProperty()
  @IsDateString()
  startDate: string;

  @ApiProperty()
  @IsDateString()
  endDate: string;

  @ApiProperty()
  @IsOptional()
  @IsString()
  @IsIn(headcounts)
  headcount: HeadcountType;

  @ApiProperty()
  @IsOptional()
  @IsString()
  @IsIn(budgets)
  budget: BudgetType;

  @ApiProperty()
  @IsString()
  @IsIn(locations)
  location: LocationType;

  @ApiProperty()
  @IsOptional()
  @IsString({ each: true })
  @ArrayMaxSize(3)
  @IsArray()
  @IsIn(themes, { each: true })
  theme: ThemeType[];

  @ApiProperty()
  @IsOptional()
  @IsString({ each: true })
  @ArrayMaxSize(3)
  @IsArray()
  @IsIn(withWhos, { each: true })
  withWho: WithWhoType[];

  @ApiProperty()
  @IsOptional()
  @IsString()
  @IsIn(vehicles)
  vehicle: VehicleType;
}
