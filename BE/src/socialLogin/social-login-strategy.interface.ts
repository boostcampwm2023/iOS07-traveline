import { SocialLoginRequestDto } from './dto/social-login-request.interface';
import { SocialWithdrawRequestDto } from './dto/social-withdraw-request.dto';

export interface SocialLoginStrategy {
  login(
    socialLoginRequestDto: SocialLoginRequestDto
  ): Promise<{ resourceId: string; email: string }>;
  withdraw(
    resourceId: string,
    socialWithdrawRequestDto: SocialWithdrawRequestDto
  ): Promise<void>;
}
