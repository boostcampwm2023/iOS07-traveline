import { Module } from '@nestjs/common';
import { BlackListService } from './blacklist.service';

@Module({ providers: [BlackListService] })
export class BlacklistModule {}
