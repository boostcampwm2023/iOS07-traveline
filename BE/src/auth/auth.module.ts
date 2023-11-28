import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { UsersModule } from 'src/users/users.module';
import { UsersService } from 'src/users/users.service';
import { StorageService } from 'src/storage/storage.service';
import { HttpModule } from '@nestjs/axios';
import { BlacklistModule } from 'src/blacklist/blacklist.module';
import { BlackListService } from 'src/blacklist/blacklist.service';

@Module({
  imports: [UsersModule, HttpModule, BlacklistModule],
  controllers: [AuthController],
  providers: [AuthService, UsersService, StorageService, BlackListService],
})
export class AuthModule {}
