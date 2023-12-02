import { ApiProperty } from '@nestjs/swagger';
import {
  IsString,
  MinLength,
  MaxLength,
  IsOptional,
  IsIn,
  ArrayMaxSize,
  IsArray,
  IsISO8601,
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
  @ApiProperty({ example: '여행 꿀팁 공유함', maxLength: 14, minLength: 1 })
  @IsString()
  @MinLength(1)
  @MaxLength(14)
  title: string;

  @ApiProperty({ example: '2023-12-13', description: 'YYYY-MM-DD 형식' })
  @IsISO8601({ strict: true })
  startDate: string;

  @ApiProperty({
    example: '2023-12-15',
    description: 'YYYY-MM-DD 형식, startDate보다 이른 날짜일 수 없습니다.',
  })
  @IsISO8601({ strict: true })
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

  @ApiProperty({
    required: false,
    enum: Theme,
    example: ['힐링', '액티비티', '맛집'],
    description: '최대 3개까지 입력할 수 있습니다.',
    isArray: true,
  })
  @IsOptional()
  @IsString({ each: true })
  @ArrayMaxSize(3)
  @IsArray()
  @IsIn(themes, { each: true })
  theme: Theme[];

  @ApiProperty({
    required: false,
    enum: WithWho,
    example: ['가족', '반려동물'],
    description: '최대 3개까지 입력할 수 있습니다.',
    isArray: true,
  })
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
