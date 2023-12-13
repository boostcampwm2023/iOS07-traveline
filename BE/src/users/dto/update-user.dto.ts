import { IsString, MaxLength, MinLength } from 'class-validator';

export class UpdateUserDto {
  @IsString()
  @MinLength(1)
  @MaxLength(14)
  name: string;
}
