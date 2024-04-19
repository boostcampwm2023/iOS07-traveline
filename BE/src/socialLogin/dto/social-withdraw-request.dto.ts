import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';

export class SocialWithdrawRequestDto {
  @ApiProperty({
    required: false,
    description: 'Kakao 계정은 idToken 없음\nApple 계정은 idToken 필수',
  })
  @IsString()
  idToken?: string;

  @ApiProperty({
    required: false,
    description:
      'Kakao 계정은 authorizationCode 없음\nApple 계정은 authorizationCode 필수',
  })
  @IsString()
  authorizationCode?: string;
}
