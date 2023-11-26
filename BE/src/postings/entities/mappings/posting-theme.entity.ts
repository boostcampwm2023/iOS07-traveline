import { PostingMapping } from './posting-mapping.entity';
import { Entity, JoinColumn, ManyToOne } from 'typeorm';
import { Theme } from '../tags/theme.entity';
import { Posting } from '../posting.entity';

@Entity('posting_theme')
export class PostingTheme extends PostingMapping {
  @ManyToOne(() => Posting, (posting) => posting.postingThemes, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'posting' })
  posting: Posting;

  @ManyToOne(() => Theme, (theme) => theme.postingTheme, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'tag' })
  tag: Theme;
}
