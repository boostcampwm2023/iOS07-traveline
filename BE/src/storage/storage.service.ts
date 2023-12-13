import { HttpService } from '@nestjs/axios';
import { BadRequestException, Injectable } from '@nestjs/common';
import { firstValueFrom } from 'rxjs';
import { v4 as uuidv4 } from 'uuid';
import * as AWS from 'aws-sdk';

@Injectable()
export class StorageService {
  constructor(private readonly httpService: HttpService) {}

  private readonly s3: AWS.S3 = new AWS.S3({
    endpoint: 'https://kr.object.ncloudstorage.com',
    region: process.env.AWS_REGION,
    credentials: {
      accessKeyId: process.env.NCP_ACCESS_KEY_ID,
      secretAccessKey: process.env.NCP_SECRET_ACCESS_KEY,
    },
  });
  private readonly bucketName = 'traveline';

  private generateFilename(originalname: string) {
    const extension = originalname.split('.').pop();
    const uniqueId = uuidv4();
    return `${uniqueId}.${extension}`;
  }

  async upload(path: string, file: Express.Multer.File) {
    const analyzeImage = await this.analyzeImage(
      file.originalname,
      file.buffer.toString('base64')
    );
    this.validateAnalyzedImage(analyzeImage);

    const uploadParams: AWS.S3.PutObjectRequest = {
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

  async delete(path: string) {
    const deleteParams: AWS.S3.DeleteObjectRequest = {
      Bucket: this.bucketName,
      Key: path,
    };

    return await this.s3.deleteObject(deleteParams).promise();
  }

  private async analyzeImage(filename: string, fileData: string) {
    const url = `https://clovagreeneye.apigw.ntruss.com/custom/v1/${process.env.GREENEYE_DOMAIN_ID}/${process.env.GREENEYE_SIGNATURE}/predict`;
    const {
      data: { images },
    } = await firstValueFrom(
      this.httpService.post(
        url,
        {
          version: 'V1',
          requestId: uuidv4(),
          timestamp: Date.now(),
          images: [{ name: filename, data: fileData }],
        },
        {
          headers: {
            'X-GREEN-EYE-SECRET': process.env.GREENEYE_SECRET_KEY,
            'Content-Type': 'application/json',
          },
        }
      )
    );

    return images[0].result;
  }

  private validateAnalyzedImage(result: {
    adult: { confidence: number };
    normal: { confidence: number };
    sexy: { confidence: number };
    porn: { confidence: number };
  }) {
    const normal = result.normal.confidence;
    const sumOfOthers =
      result.adult.confidence + result.porn.confidence + result.sexy.confidence;

    if (normal < sumOfOthers) {
      throw new BadRequestException('유해한 이미지가 포함되어 있습니다.');
    }
  }
}
