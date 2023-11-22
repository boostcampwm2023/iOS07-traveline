import { Entity, OneToMany } from 'typeorm';
import { Posting } from '../posting.entity';
import { Tag } from './tag.entity';

@Entity()
export class Headcount extends Tag {
  @OneToMany(() => Posting, (posting) => posting.headcount)
  postings: Posting[];
}
