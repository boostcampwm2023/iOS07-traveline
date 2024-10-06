import { Module } from '@nestjs/common';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { usersProvider } from './users.providers';
import { UserRepository } from './users.repository';
import { StorageModule } from '../storage/storage.module';
import { DatabaseModule } from '../database/database.module';
import { BlockRepository } from './block.repository';

@Module({
  imports: [DatabaseModule, StorageModule],
  controllers: [UsersController],
  providers: [UsersService, ...usersProvider, UserRepository, BlockRepository],
  exports: [UserRepository, UsersService, BlockRepository],
})
export class UsersModule {}
