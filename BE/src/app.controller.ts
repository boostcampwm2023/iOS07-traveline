import {
  Controller,
  Get,
  Param,
  Post,
  Render,
  Res,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { AppService } from './app.service';
import { StorageService } from './storage/storage.service';
import { FileInterceptor } from '@nestjs/platform-express';

@Controller()
export class AppController {
  constructor(
    private readonly appService: AppService,
    private readonly storageService: StorageService
  ) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
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

  @Get('email')
  async email() {
    return this.appService.sendEmail();
  }

  @Get('ip-process-result')
  @Render('ip-process-result.ejs')
  ipProcessResult() {
    return {};
  }
}
