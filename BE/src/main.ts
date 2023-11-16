import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { LoggingInterceptor } from './logging/logging.interceptor';
import { HttpExceptionFilter } from './exception/exception.filter';
import { setupSwagger } from './swagger/swagger.setting';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.useGlobalInterceptors(new LoggingInterceptor());
  app.useGlobalFilters(new HttpExceptionFilter());
  setupSwagger(app);
  await app.listen(3000);
}
bootstrap();
