import { PostingTheme } from '../mapping/posting-theme.entity';
import { Tag } from './tag.entity';
import { Entity, OneToMany } from 'typeorm';

@Entity()
export class Theme extends Tag {
  @OneToMany(() => PostingTheme, (postingTheme) => postingTheme.themes)
  postingThemes: PostingTheme[];
}
