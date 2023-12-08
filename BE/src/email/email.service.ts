import * as AWS from 'aws-sdk';
import * as ejs from 'ejs';

export class EmailService {
  private readonly ses: AWS.SES = new AWS.SES({
    region: process.env.AWS_REGION,
    credentials: {
      accessKeyId: process.env.AWS_ACCESS_KEY_ID,
      secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
    },
  });

  async sendEmail(email: string, title: string, html: string) {
    const sendEmailParams: AWS.SES.SendEmailRequest = {
      Destination: {
        CcAddresses: [],
        ToAddresses: [email], // 받을 사람의 이메일
      },
      Message: {
        Body: {
          Html: {
            Charset: 'UTF-8',
            Data: html,
          },
        },
        Subject: {
          Charset: 'UTF-8',
          Data: title,
        },
      },
      Source: 'no-reply@traveline.store',
      ReplyToAddresses: [],
    };
    const result = await this.ses.sendEmail(sendEmailParams).promise();
    return result;
  }

  async template(ejsFileName: string, data: object) {
    const path = __dirname + '/../../views/' + ejsFileName; // ejs 파일 경로

    let html;
    await ejs.renderFile(path, data, async (err, res) => {
      if (!err) {
        html = res;
      }
    });
    return html;
  }
}
