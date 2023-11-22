import { Entity, JoinColumn, ManyToOne, PrimaryColumn } from 'typeorm';
import { Posting } from '../posting.entity';
import { Theme } from '../tags/theme.entity';

@Entity('posting_theme')
export class PostingTheme {
  @PrimaryColumn({ type: 'char', length: 36 })
  posting: string;

  @PrimaryColumn()
  theme: number;

  @ManyToOne(() => Posting, (posting) => posting.postingThemes, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'posting' })
  postings: Posting;

  @ManyToOne(() => Theme, (theme) => theme.postingThemes, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'theme' })
  themes: Theme;
}
