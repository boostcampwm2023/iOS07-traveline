import { Entity, JoinColumn, ManyToOne, PrimaryColumn } from 'typeorm';
import { User } from 'src/users/entities/user.entity';
import { Posting } from './posting.entity';

@Entity()
export class Report {
  @PrimaryColumn({ type: 'char', length: 36 })
  reporter: string;

  @PrimaryColumn({ type: 'char', length: 36 })
  posting: string;

  @ManyToOne(() => User, (user) => user.reports, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'reporter', referencedColumnName: 'id' })
  reporters: User;

  @ManyToOne(() => Posting, (posting) => posting.reports, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'posting', referencedColumnName: 'id' })
  postings: Posting;
}
