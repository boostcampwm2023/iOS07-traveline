import { Cron, CronExpression } from '@nestjs/schedule';

export class BlackListService {
  constructor(
    private accessTokenBlacklist: Map<string, number>,
    private refreshTokenBlacklist: Map<string, number>
  ) {}

  @Cron(CronExpression.EVERY_HOUR)
  deleteExpiredToken() {
    for (const [token, exp] of this.accessTokenBlacklist) {
      if (Date.now() >= exp * 1000) {
        this.accessTokenBlacklist.delete(token);
      }
    }
    for (const [token, exp] of this.refreshTokenBlacklist) {
      if (Date.now() >= exp * 1000) {
        this.refreshTokenBlacklist.delete(token);
      }
    }
  }

  addAccessTokenToBlacklist(token: string, exp: number) {
    this.accessTokenBlacklist.set(token, exp);
  }

  addRefreshTokenToBlacklist(token: string, exp: number) {
    this.refreshTokenBlacklist.set(token, exp);
  }

  checkAccessTokenBlacklist(token) {
    return this.accessTokenBlacklist.has(token);
  }

  checkRefreshTokenBlacklist(token) {
    return this.refreshTokenBlacklist.has(token);
  }
}
