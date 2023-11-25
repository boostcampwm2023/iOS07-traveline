import { Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { Posting } from '../posting.entity';
import { Theme } from '../tags/theme.entity';

@Entity('posting_theme')
export class PostingTheme {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => Posting, (posting) => posting.postingThemes, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'posting' })
  posting: Posting;

  @ManyToOne(() => Theme, (theme) => theme.postingTheme, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'theme' })
  theme: Theme;
}
