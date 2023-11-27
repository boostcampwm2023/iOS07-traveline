import { StorageService } from './storage/storage.service';
import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  constructor(private readonly storageService: StorageService) {}

  getHello(): string {
    return 'Hello World!';
  }

  async download(filename: string) {
    return this.storageService.getImageUrl(`app/${filename}`);
  }
}
