import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { Liked } from './liked.entity';
import { Report } from './report.entity';
import { User } from '../../users/entities/user.entity';
import { Timeline } from '../../timelines/entities/timeline.entity';
import {
  Budget,
  Headcount,
  Location,
  Period,
  Season,
  Theme,
  Vehicle,
  WithWho,
} from '../postings.types';

@Entity()
export class Posting {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User, (user) => user.postings, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'writer' })
  writer: User;

  @Column({ length: 14 })
  title: string;

  @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
  createdAt: Date;

  @Column({ length: 255, nullable: true, default: null })
  thumbnail: string;

  @Column({ name: 'start_date', type: 'date' })
  startDate: Date;

  @Column({ name: 'end_date', type: 'date' })
  endDate: Date;

  @Column({ type: 'int' })
  days: number;

  @Column({ length: 14 })
  period: Period;

  @Column({ length: 14, nullable: true })
  headcount: Headcount;

  @Column({ length: 14, nullable: true })
  budget: Budget;

  @Column({ length: 14 })
  location: Location;

  @Column({ length: 14 })
  season: Season;

  @Column({ length: 14, nullable: true })
  vehicle: Vehicle;

  @Column({ type: 'json', nullable: true })
  theme: Theme[];

  @Column({ name: 'with_who', type: 'json', nullable: true })
  withWho: WithWho[];

  @OneToMany(() => Timeline, (timeline) => timeline.posting)
  timelines: Timeline[];

  @OneToMany(() => Liked, (liked) => liked.postings)
  likeds: Liked[];

  @OneToMany(() => Report, (report) => report.postings)
  reports: Report[];
}
