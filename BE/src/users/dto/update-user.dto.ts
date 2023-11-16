import { ApiProperty, PartialType } from '@nestjs/swagger';
import { IsOptional, IsString, MaxLength, MinLength } from 'class-validator';
import { CreateAuthDto } from 'src/auth/dto/create-auth.dto';

export class UpdateUserDto extends PartialType(CreateAuthDto) {
  @IsOptional()
  @IsString()
  @MinLength(1)
  @MaxLength(14)
  @ApiProperty()
  name: string;

  @IsString()
  @IsOptional()
  @ApiProperty()
  avatar: string;
}
