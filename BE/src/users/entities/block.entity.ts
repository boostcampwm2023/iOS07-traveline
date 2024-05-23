import { Entity, PrimaryGeneratedColumn, ManyToOne, JoinColumn } from 'typeorm';
import { User } from './user.entity';

@Entity()
export class Block {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User, (user) => user.blockers, { nullable: false })
  @JoinColumn({ name: 'blocker', referencedColumnName: 'id' })
  blocker: User;

  @ManyToOne(() => User, (user) => user.blockeds, { nullable: false })
  @JoinColumn({ name: 'blocked', referencedColumnName: 'id' })
  blocked: User;
}
