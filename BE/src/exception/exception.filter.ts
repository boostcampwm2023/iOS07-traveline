import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  InternalServerErrorException,
} from '@nestjs/common';
import { winstonLogger } from 'src/logging/logging.logger';

@Catch()
export class HttpExceptionFilter implements ExceptionFilter {
  catch(exception: any, host: ArgumentsHost) {
    const context = host.switchToHttp();
    const response = context.getResponse();
    const request = context.getRequest();

    if (!(exception instanceof HttpException)) {
      exception = new InternalServerErrorException();
    }

    winstonLogger.log(
      `Response from ${request.method} ${
        request.url
      }\nresponse: ${JSON.stringify(
        (exception as HttpException).getResponse()
      )}`
    );

    response
      .status((exception as HttpException).getStatus())
      .json((exception as HttpException).getResponse());
  }
}
