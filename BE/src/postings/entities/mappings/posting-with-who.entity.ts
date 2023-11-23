import { Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { WithWho } from '../tags/with-who.entity';
import { Posting } from '../posting.entity';

@Entity('posting_with_who')
export class PostingWithWho {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => Posting, (posting) => posting.postingWithWhos, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'posting' })
  posting: Posting;

  @ManyToOne(() => WithWho, (withWho) => withWho.postingWithWho, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'with_who' })
  withWho: WithWho;
}
