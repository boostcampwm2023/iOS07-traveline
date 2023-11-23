import { Module } from '@nestjs/common';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { StorageService } from 'src/storage/storage.service';
import { usersProvider } from './users.providers';
import { UserRepository } from './users.repository';
import { DatabaseModule } from 'src/database/database.module';

@Module({
  imports: [DatabaseModule],
  controllers: [UsersController],
  providers: [UsersService, StorageService, ...usersProvider, UserRepository],
  exports: [UserRepository, UsersService],
})
export class UsersModule {}
