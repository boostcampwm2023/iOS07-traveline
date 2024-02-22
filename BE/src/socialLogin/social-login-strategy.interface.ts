import { SocialLoginRequestDto } from './dto/social-login-request.interface';

export interface SocialLoginStrategy {
  login(
    socialLoginRequestDto: SocialLoginRequestDto
  ): Promise<{ resourceId: string; email: string }>;
  withdraw(resourceId: string): Promise<void>;
}
