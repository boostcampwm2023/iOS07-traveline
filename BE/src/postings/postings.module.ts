import { Module } from '@nestjs/common';
import { PostingsService } from './postings.service';
import { PostingsController } from './postings.controller';
import { DatabaseModule } from 'src/database/database.module';
import { postingsProviders } from './postings.providers';
import { PostingsRepository } from './repositories/postings.repository';
import { LikedsRepository } from './repositories/likeds.repository';
import { ReportsRepository } from './repositories/reports.repository';
import { BudgetsRepository } from './repositories/tags/budgets.repository';
import { HeadcountsRepository } from './repositories/tags/headcounts.repository';
import { LocationsRepository } from './repositories/tags/locations.repository';
import { PeriodsRepository } from './repositories/tags/periods.repository';
import { SeasonsRepository } from './repositories/tags/seasons.repository';
import { ThemesRepository } from './repositories/tags/themes.repository';
import { VehiclesRepository } from './repositories/tags/vehicles.repository';
import { WithWhosRepository } from './repositories/tags/with-whos.repository';
import { PostingThemesRepository } from './repositories/mappings/posting-themes.repository';
import { PostingWithWhosRepository } from './repositories/mappings/posting-with-whos.repository';

@Module({
  imports: [DatabaseModule],
  controllers: [PostingsController],
  providers: [
    ...postingsProviders,
    PostingsService,
    PostingsRepository,
    LikedsRepository,
    ReportsRepository,
    BudgetsRepository,
    HeadcountsRepository,
    LocationsRepository,
    PeriodsRepository,
    SeasonsRepository,
    ThemesRepository,
    VehiclesRepository,
    WithWhosRepository,
    PostingThemesRepository,
    PostingWithWhosRepository,
  ],
})
export class PostingsModule {}
