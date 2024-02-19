import { LoginRequestDto } from 'src/auth/dto/login-request.dto.interface';

export interface SocialLoginStrategy {
  login(loginRequestDto: LoginRequestDto): Promise<string>;
  refresh(): void;
  withdraw(resourceId: string): void;
}
