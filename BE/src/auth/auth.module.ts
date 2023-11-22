import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { UsersModule } from 'src/users/users.module';
import { UsersService } from 'src/users/users.service';
import { StorageService } from 'src/storage/storage.service';
import { JwtModule } from '@nestjs/jwt';

@Module({
  imports: [
    UsersModule,
    JwtModule.register({
      global: true,
      secret: 'traveline_is_the_best', //.env에 넣어서 이용하고 싶었는데,,, 뭔가 문제가 있는지 읽어오는데 문제가 있네요ㅠㅠ
      signOptions: { expiresIn: '900s' },
    }),
  ],
  controllers: [AuthController],
  providers: [AuthService, UsersService, StorageService],
})
export class AuthModule {}
