import {
  IsString,
  IsEmail,
  MinLength,
  MaxLength,
  IsOptional,
} from 'class-validator';
import { SocialLoginRequestDto } from './social-login-request.interface';

export class AppleLoginRequestDto implements SocialLoginRequestDto {
  @IsString()
  idToken: string;

  @IsEmail()
  @MinLength(4)
  @MaxLength(35)
  @IsOptional()
  email?: string;
}
