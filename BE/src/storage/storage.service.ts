import { Injectable } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import * as AWS from 'aws-sdk';

@Injectable()
export class StorageService {
  private readonly s3: AWS.S3 = new AWS.S3({
    endpoint: 'https://kr.object.ncloudstorage.com',
    region: process.env.AWS_REGION,
    credentials: {
      accessKeyId: process.env.AWS_ACCESS_KEY_ID,
      secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
    },
  });
  private readonly bucketName = 'traveline';

  private generateFilename(originalname: string) {
    const extension = originalname.split('.').pop();
    const uniqueId = uuidv4();
    return `${uniqueId}.${extension}`;
  }

  async upload(path: string, file: Express.Multer.File) {
    const uploadParams = {
      Bucket: this.bucketName,
      Key: path + this.generateFilename(file.originalname),
      Body: file.buffer,
      ACL: 'public-read',
    };

    const result = await this.s3.upload(uploadParams).promise();

    return {
      imageUrl: result.Location,
      path: uploadParams.Key,
    };
  }

  async getImageUrl(key: string): Promise<string> {
    const params: AWS.S3.GetObjectRequest = {
      Bucket: this.bucketName,
      Key: key,
    };

    const signedUrl = await this.s3.getSignedUrlPromise('getObject', params);
    return signedUrl;
  }
}
