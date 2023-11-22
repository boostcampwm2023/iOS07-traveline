import { PostingWithWho } from '../mappings/posting-with-who.entity';
import { Entity, OneToMany } from 'typeorm';
import { Tag } from './tag.entity';

@Entity('with_who')
export class WithWho extends Tag {
  @OneToMany(() => PostingWithWho, (postingWithWho) => postingWithWho.withWhos)
  postingWithWhos: PostingWithWho[];
}
