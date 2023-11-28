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
  Budget,
  Headcount,
  Location,
  Theme,
  Vehicle,
  WithWho,
  budgets,
  headcounts,
  locations,
  themes,
  vehicles,
  withWhos,
} from '../postings.types';

export class CreatePostingDto {
  @ApiProperty({ example: 'test title' })
  @IsString()
  @MinLength(1)
  @MaxLength(14)
  title: string;

  @ApiProperty({ example: '2023-12-13' })
  @IsDateString()
  startDate: string;

  @ApiProperty({ example: '2023-12-15' })
  @IsDateString()
  endDate: string;

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

  @ApiProperty({ enum: Location })
  @IsString()
  @IsIn(locations)
  location: Location;

  @ApiProperty({ required: false, enum: Theme })
  @IsOptional()
  @IsString({ each: true })
  @ArrayMaxSize(3)
  @IsArray()
  @IsIn(themes, { each: true })
  theme: Theme[];

  @ApiProperty({ required: false, enum: WithWho })
  @IsOptional()
  @IsString({ each: true })
  @ArrayMaxSize(3)
  @IsArray()
  @IsIn(withWhos, { each: true })
  withWho: WithWho[];

  @ApiProperty({ required: false, enum: Vehicle })
  @IsOptional()
  @IsString()
  @IsIn(vehicles)
  vehicle: Vehicle;
}
