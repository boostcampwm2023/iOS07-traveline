import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryColumn,
} from 'typeorm';
import { Liked } from './liked.entity';
import { Report } from './report.entity';
import { User } from 'src/users/entities/user.entity';
import { Timeline } from 'src/timelines/entities/timeline.entity';

@Entity()
export class Posting {
  @PrimaryColumn({ type: 'char', length: 36 })
  id: string;

  @Column({ type: 'char', length: 36, nullable: true })
  writer: string;

  @Column({ length: 14 })
  title: string;

  @CreateDateColumn({ type: 'timestamp' })
  created_at: Date;

  @Column({ length: 255, nullable: true, default: null })
  thumbnail: string;

  @Column({ type: 'int', default: 0 })
  liked: number;

  @Column({ type: 'date' })
  start_date: Date;

  @Column({ type: 'date' })
  end_date: Date;

  @Column({ type: 'int' })
  days: number;

  @Column({ type: 'int' })
  period: number;

  @Column({ type: 'int', nullable: true })
  headcount: number;

  @Column({ type: 'int', nullable: true })
  budget: number;

  @Column({ type: 'int' })
  location: number;

  @Column({ type: 'json', nullable: true, default: null })
  theme: number[];

  @Column({ type: 'json', nullable: true, default: null })
  with_who: number[];

  @Column({ type: 'int' })
  season: number;

  @Column({ type: 'int', nullable: true })
  vehicle: number;

  @Column({ type: 'int', default: 0 })
  report: number;

  @ManyToOne(() => User, (user) => user.postings, {
    onDelete: 'SET NULL',
    onUpdate: 'CASCADE',
  })
  @JoinColumn({ name: 'writer', referencedColumnName: 'id' })
  writers: User;

  @OneToMany(() => Timeline, (timeline) => timeline.postings)
  timelines: Timeline[];

  @OneToMany(() => Liked, (liked) => liked.postings)
  likeds: Liked[];

  @OneToMany(() => Report, (report) => report.postings)
  reports: Report[];
}
