import { Column, Entity, JoinColumn, ManyToOne, PrimaryColumn } from 'typeorm';
import { User } from 'src/users/entities/user.entity';
import { Posting } from './posting.entity';

@Entity()
export class Liked {
  @PrimaryColumn({ type: 'char', length: 36 })
  user: string;

  @PrimaryColumn({ type: 'char', length: 36 })
  posting: string;

  @Column({ name: 'is_deleted', type: 'bool', default: false })
  isDeleted: boolean;

  @ManyToOne(() => User, (user) => user.likeds, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'user', referencedColumnName: 'id' })
  users: User;

  @ManyToOne(() => Posting, (posting) => posting.likeds, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'posting', referencedColumnName: 'id' })
  postings: Posting;
}
