import { LoginRequestDto } from './login-request.dto.interface';
import { IsString } from 'class-validator';

export class KakaoLoginRequestDto implements LoginRequestDto {
  @IsString()
  idToken: string;
}
