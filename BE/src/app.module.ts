import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { UsersModule } from './users/users.module';
import { PostingsModule } from './postings/postings.module';
import { TimelinesModule } from './timelines/timelines.module';
import { AuthModule } from './auth/auth.module';

@Module({
  imports: [UsersModule, PostingsModule, TimelinesModule, AuthModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
