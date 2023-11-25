import { PostingTheme } from '../mappings/posting-theme.entity';
import { Tag } from './tag.entity';
import { Entity, OneToMany } from 'typeorm';

@Entity()
export class Theme extends Tag {
  @OneToMany(() => PostingTheme, (postingTheme) => postingTheme.theme)
  postingTheme: PostingTheme[];
}
