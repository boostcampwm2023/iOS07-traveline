import { AuthGuard } from './auth.guard';
import { APP_GUARD } from '@nestjs/core';

export const authProviders = [{ provide: APP_GUARD, useClass: AuthGuard }];
