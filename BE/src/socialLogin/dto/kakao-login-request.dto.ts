import { LoginRequestDto } from './social-login-request.interface';
import { IsString } from 'class-validator';

export class KakaoLoginRequestDto implements LoginRequestDto {
  @IsString()
  idToken: string;
}
