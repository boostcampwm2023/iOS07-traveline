import { StorageService } from './storage.service';
import { HttpModule } from '@nestjs/axios';
import { Module } from '@nestjs/common';

@Module({
  imports: [HttpModule],
  providers: [StorageService],
  exports: [StorageService],
})
export class StorageModule {}
