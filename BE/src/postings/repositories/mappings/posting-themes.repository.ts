import { PostingTheme } from 'src/postings/entities/mappings/posting-theme.entity';
import { POSTING_THEMES_REPOSITORY } from '../../postings.constants';
import { Inject, Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';

@Injectable()
export class PostingThemesRepository {
  constructor(
    @Inject(POSTING_THEMES_REPOSITORY)
    private postingThemesRepository: Repository<PostingTheme>
  ) {}
}
