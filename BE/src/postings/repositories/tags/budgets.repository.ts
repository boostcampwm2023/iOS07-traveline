import { BUDGETS_REPOSITORY } from '../../postings.constants';
import { Budget } from '../../entities/tags/budget.entity';
import { Inject, Injectable } from '@nestjs/common';
import { TagRepository } from './tag.repository';
import { Repository } from 'typeorm';

@Injectable()
export class BudgetsRepository extends TagRepository<Budget> {
  constructor(
    @Inject(BUDGETS_REPOSITORY)
    private budgetsRepository: Repository<Budget>
  ) {
    super(budgetsRepository);
  }
}
