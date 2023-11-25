import { REPORTS_REPOSITORY } from '../postings.constants';
import { Inject, Injectable } from '@nestjs/common';
import { Report } from '../entities/report.entity';
import { Repository } from 'typeorm';

@Injectable()
export class ReportsRepository {
  constructor(
    @Inject(REPORTS_REPOSITORY)
    private reportsRepository: Repository<Report>
  ) {}
}
