import { Entity, OneToMany } from 'typeorm';
import { Posting } from '../posting.entity';
import { Tag } from './tag.entity';

@Entity()
export class Season extends Tag {
  @OneToMany(() => Posting, (posting) => posting.season)
  postings: Posting[];
}
