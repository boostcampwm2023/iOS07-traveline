import { SocialWithdrawRequestDto } from './dto/social-withdraw-request.dto';
import { SocialLoginRequestDto } from './dto/social-login-request.dto';

export interface SocialLoginStrategy {
  login(
    socialLoginRequestDto: SocialLoginRequestDto
  ): Promise<{ resourceId: string; email: string }>;
  withdraw(
    resourceId: string,
    socialWithdrawRequestDto: SocialWithdrawRequestDto
  ): Promise<void>;
}
