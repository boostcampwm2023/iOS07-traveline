import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { UsersModule } from 'src/users/users.module';
import { UsersService } from 'src/users/users.service';
import { StorageService } from 'src/storage/storage.service';
import { HttpModule } from '@nestjs/axios';
import { AuthGuard } from './auth.guard';
import { EmailModule } from 'src/email/email.module';

@Module({
  imports: [UsersModule, HttpModule, EmailModule],
  controllers: [AuthController],
  providers: [AuthService, UsersService, StorageService, AuthGuard],
})
export class AuthModule {}
