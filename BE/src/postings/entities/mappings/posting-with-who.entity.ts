import { Entity, JoinColumn, ManyToOne, PrimaryColumn } from 'typeorm';
import { WithWho } from '../tags/with-who.entity';
import { Posting } from '../posting.entity';

@Entity('posting_with_who')
export class PostingWithWho {
  @PrimaryColumn({ type: 'char', length: 36 })
  posting: string;

  @PrimaryColumn({ name: 'with_who' })
  withWho: number;

  @ManyToOne(() => Posting, (posting) => posting.postingWithWhos, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'posting' })
  postings: Posting;

  @ManyToOne(() => WithWho, (withWho) => withWho.postingWithWhos, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'with_who' })
  withWhos: WithWho;
}
