import { Entity, OneToMany } from 'typeorm';
import { Posting } from '../posting.entity';
import { Tag } from './tag.entity';

@Entity()
export class Vehicle extends Tag {
  @OneToMany(() => Posting, (posting) => posting.vehicle)
  postings: Posting[];
}
