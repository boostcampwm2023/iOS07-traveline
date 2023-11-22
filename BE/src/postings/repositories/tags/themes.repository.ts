import { THEMES_REPOSITORY } from '../../postings.constants';
import { Theme } from '../../entities/tags/theme.entity';
import { Inject, Injectable } from '@nestjs/common';
import { TagRepository } from './tag.repository';
import { Repository } from 'typeorm';

@Injectable()
export class ThemesRepository extends TagRepository<Theme> {
  constructor(
    @Inject(THEMES_REPOSITORY)
    private themesRepository: Repository<Theme>
  ) {
    super(themesRepository);
  }
}
