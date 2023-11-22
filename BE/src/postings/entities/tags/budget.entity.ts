import { Entity, OneToMany } from 'typeorm';
import { Posting } from '../posting.entity';
import { Tag } from './tag.entity';

@Entity()
export class Budget extends Tag {
  @OneToMany(() => Posting, (posting) => posting.budget)
  postings: Posting[];
}
