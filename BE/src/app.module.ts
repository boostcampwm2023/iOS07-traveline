import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { UsersModule } from './users/users.module';
import { PostingsModule } from './postings/postings.module';
import { TimelinesModule } from './timelines/timelines.module';
import { AuthModule } from './auth/auth.module';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { DatabaseModule } from './database/database.module';
// import { StorageModule } from './storage/storage.module';
import { FileModule } from './file/file.module';
import { JwtModule } from '@nestjs/jwt';
import { EmailModule } from './email/email.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      envFilePath: `.env`,
      isGlobal: true,
    }),
    JwtModule.register({
      global: true,
      secret: process.env.JWT_SECRET_ACCESS,
      signOptions: { expiresIn: '30d' },
    }),
    // StorageModule,
    FileModule,
    UsersModule,
    PostingsModule,
    TimelinesModule,
    AuthModule,
    DatabaseModule,
    EmailModule,
  ],
  controllers: [AppController],
  providers: [AppService, ConfigService],
})
export class AppModule {}
