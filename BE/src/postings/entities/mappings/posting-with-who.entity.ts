import { PostingMapping } from './posting-mapping.entity';
import { Entity, JoinColumn, ManyToOne } from 'typeorm';
import { WithWho } from '../tags/with-who.entity';
import { Posting } from '../posting.entity';

@Entity('posting_with_who')
export class PostingWithWho extends PostingMapping {
  @ManyToOne(() => Posting, (posting) => posting.postingWithWhos, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'posting' })
  posting: Posting;

  @ManyToOne(() => WithWho, (withWho) => withWho.postingWithWho, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'tag' })
  tag: WithWho;
}
