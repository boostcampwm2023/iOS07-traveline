import { Entity, OneToMany } from 'typeorm';
import { Posting } from '../posting.entity';
import { Tag } from './tag.entity';

@Entity()
export class Location extends Tag {
  @OneToMany(() => Posting, (posting) => posting.location)
  postings: Posting[];
}
