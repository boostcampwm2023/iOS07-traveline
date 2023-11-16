import { User } from 'src/users/entities/user.entity';
import { Posting } from './posting.entity';
import { Entity, JoinColumn, ManyToOne, PrimaryColumn } from 'typeorm';

@Entity()
export class Liked {
  @PrimaryColumn({ type: 'char', length: 36 })
  user: string;

  @PrimaryColumn({ type: 'char', length: 36 })
  posting: string;

  @ManyToOne(() => User, (user) => user.likeds, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  @JoinColumn({ name: 'user', referencedColumnName: 'id' })
  users: User;

  @ManyToOne(() => Posting, (posting) => posting.likeds, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  @JoinColumn({ name: 'posting', referencedColumnName: 'id' })
  postings: Posting;
}
