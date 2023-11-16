import * as winstonDaily from 'winston-daily-rotate-file';
import { WinstonModule } from 'nest-winston';
import { format } from 'winston';

const logDir = process.cwd() + '/logs';
const { combine, timestamp, label, printf } = format;
const logFormat = printf(({ level, message, label, timestamp }) => {
  return `[${label}] ${level} ${timestamp} ${message}`;
});

export const winstonLogger = WinstonModule.createLogger({
  level: 'verbose',
  format: combine(
    label({ label: 'Trapture' }),
    timestamp({ format: 'HH:mm:ss' }),
    logFormat
  ),
  transports: [
    new winstonDaily({
      level: 'verbose',
      datePattern: 'YYYY-MM-DD',
      dirname: logDir,
      filename: `log`,
      maxFiles: 7,
      zippedArchive: true,
    }),
  ],
});
