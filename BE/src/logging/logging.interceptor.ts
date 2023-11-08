import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { winstonLogger } from './logging.logger';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const req = context.switchToHttp().getRequest();
    const { method, url, body } = req;
    winstonLogger.log(
      `Request to ${method} ${url}\nbody: ${JSON.stringify(body)}`
    );

    return next
      .handle()
      .pipe(
        tap((data) =>
          winstonLogger.log(
            `Response from ${method} ${url}\nresponse: ${JSON.stringify(data)}`
          )
        )
      );
  }
}
