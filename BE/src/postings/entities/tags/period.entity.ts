import { Entity, OneToMany } from 'typeorm';
import { Posting } from '../posting.entity';
import { Tag } from './tag.entity';

@Entity()
export class Period extends Tag {
  @OneToMany(() => Posting, (posting) => posting.period)
  postings: Posting[];
}
