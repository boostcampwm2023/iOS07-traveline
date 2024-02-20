import { LoginRequestDto } from 'src/auth/dto/login-request.dto.interface';

export interface SocialLoginStrategy {
  login(
    loginRequestDto: LoginRequestDto
  ): Promise<{ resourceId: string; email: string }>;
  withdraw(resourceId: string): Promise<void>;
}
