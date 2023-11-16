import { ApiProperty } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';

export class SearchPostingDto {
  @ApiProperty()
  @IsOptional()
  @IsString()
  keyword: string;

  @ApiProperty()
  @IsOptional()
  @IsString()
  period: string;

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
  season: string;

  @ApiProperty()
  @IsOptional()
  @IsString()
  veihicle: string;
}
