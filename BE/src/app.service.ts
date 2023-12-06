import { MailerService } from '@nestjs-modules/mailer';
import { StorageService } from './storage/storage.service';
import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  constructor(
    private readonly storageService: StorageService,
    private readonly mailerService: MailerService
  ) {}

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
        font-family: verdana;
        font-size: 80px;
      }

      a {
        color: #B15EFF;
        font-family: verdana;
        font-size: 60px;
      }

      p {
        color: #AAAAAA;
        font-family: verdana;
        font-size: 50px;
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
      </html>`;
  }

  async download(filename: string) {
    return this.storageService.getImageUrl(`app/${filename}`);
  }

  async sendEmail() {
    try {
      const result = await this.mailerService.sendMail({
        to: 'minnie_00@naver.com',
        subject: '이메일 테스트',
        template: 'test.ejs',
        context: {
          serviceName: 'traveline',
        },
      });
      return result;
    } catch (e) {
      console.log(e);
    }
  }
}
