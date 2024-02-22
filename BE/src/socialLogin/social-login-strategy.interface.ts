import { LoginRequestDto } from './dto/social-login-request.interface';

export interface SocialLoginStrategy {
  login(
    loginRequestDto: LoginRequestDto
  ): Promise<{ resourceId: string; email: string }>;
  withdraw(resourceId: string): Promise<void>;
}
