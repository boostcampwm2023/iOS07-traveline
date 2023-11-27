import {
  Controller,
  Get,
  Param,
  Post,
  Res,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { AppService } from './app.service';
import { StorageService } from './storage/storage.service';
import { FileInterceptor } from '@nestjs/platform-express';
import { request } from 'http';

@Controller()
export class AppController {
  constructor(
    private readonly appService: AppService,
    private readonly storageService: StorageService
  ) {}

  @Get()
  getHello(): string {
    return `
    <!DOCTYPE html>
      <html>
      <head>
      <style>
      body {
        background-color: #0F1012;
      }

      h1 {
        color: white;
      }

      a {
        color: #B15EFF;
        font-family: verdana;
        font-size: 20px;
      }

      p {
        color: #AAAAAA;
        font-family: verdana;
        font-size: 12px;
      }

      </style>
      </head>
      <body>

      <h1>traveline</h1>
      <a href="itms-services://?action=download-manifest&amp;url=https://traveline.store/apps/manifest.plist">v1-다운로드</a>

      <p>
      Last updated: 2023-11-27 16:30
      </p>

      </body>
      </html>
      `;
  }

  @Post('/upload')
  @UseInterceptors(FileInterceptor('file'))
  async upload(@UploadedFile() file: Express.Multer.File) {
    return this.storageService.upload('', file);
  }

  @Get('apps/:filename')
  async ipa(@Res() response, @Param('filename') filename: string) {
    const url = await this.appService.download(filename);
    response.redirect(url);
  }
}
