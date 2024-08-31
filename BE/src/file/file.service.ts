import { BadRequestException, Injectable } from '@nestjs/common';
import { unlink, writeFile } from 'fs/promises';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class FileService {
  private readonly basePath = 'static/';

  constructor() {}

  private generateFilename(originalname: string) {
    const extension = originalname.split('.').pop();
    const uniqueId = uuidv4();
    return `${uniqueId}.${extension}`;
  }

  async upload(path: string, file: Express.Multer.File) {
    const filePath =
      this.basePath + path + this.generateFilename(file.originalname);
    await writeFile(filePath, file.buffer);

    return {
      imageUrl: filePath,
      path: filePath,
    };
  }

  async getImageUrl(key: string): Promise<string> {
    return this.basePath + key;
  }

  async delete(path: string) {
    await unlink(this.basePath + path);
  }
}
