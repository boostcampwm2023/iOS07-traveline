import { SocialLoginRequestDto } from './social-login-request.interface';
import { IsString } from 'class-validator';

export class KakaoLoginRequestDto implements SocialLoginRequestDto {
  @IsString()
  idToken: string;
}
