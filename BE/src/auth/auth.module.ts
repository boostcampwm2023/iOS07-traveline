import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { UsersModule } from 'src/users/users.module';
import { UsersService } from 'src/users/users.service';
import { StorageService } from 'src/storage/storage.service';
import { HttpModule } from '@nestjs/axios';

@Module({
  imports: [UsersModule, HttpModule],
  controllers: [AuthController],
  providers: [AuthService, UsersService, StorageService],
})
export class AuthModule {}
