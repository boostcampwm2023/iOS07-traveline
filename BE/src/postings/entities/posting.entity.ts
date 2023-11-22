import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryColumn,
  RelationId,
} from 'typeorm';
import { Liked } from './liked.entity';
import { Report } from './report.entity';
import { User } from 'src/users/entities/user.entity';
import { Timeline } from 'src/timelines/entities/timeline.entity';
import { PostingTheme } from './mapping/posting-theme.entity';
import { PostingWithWho } from './mapping/posting-with-who.entity';
import { Budget } from './tags/budget.entity';
import { Season } from './tags/season.entity';
import { Vehicle } from './tags/vehicle.entity';
import { Period } from './tags/period.entity';
import { Location } from './tags/location.entity';
import { Headcount } from './tags/headcount.entity';

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

  @RelationId((posting: Posting) => posting.likeds)
  liked: { user: string; posting: string }[];

  @Column({ type: 'date' })
  start_date: Date;

  @Column({ type: 'date' })
  end_date: Date;

  @Column({ type: 'int' })
  days: number;

  @ManyToOne(() => Period, (period) => period.postings, { nullable: false })
  @JoinColumn({ name: 'period' })
  period: number;

  @ManyToOne(() => Headcount, (headcount) => headcount.postings)
  @JoinColumn({ name: 'headcount' })
  headcount: number;

  @ManyToOne(() => Budget, (budget) => budget.postings)
  @JoinColumn({ name: 'budget' })
  budget: Budget;

  @ManyToOne(() => Location, (location) => location.postings, {
    nullable: false,
  })
  @JoinColumn({ name: 'location' })
  location: number;

  @ManyToOne(() => Season, (season) => season.postings, { nullable: false })
  @JoinColumn({ name: 'season' })
  season: number;

  @ManyToOne(() => Vehicle, (vehicle) => vehicle.postings)
  @JoinColumn({ name: 'vehicle' })
  vehicle: number;

  @RelationId((posting: Posting) => posting.reports)
  report: { reporter: string; posting: string }[];

  @ManyToOne(() => User, (user) => user.postings, {
    onDelete: 'CASCADE',
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

  @OneToMany(() => PostingTheme, (postingTheme) => postingTheme.postings)
  postingThemes: PostingTheme[];

  @OneToMany(
    () => PostingWithWho,
    (postingWithWhos) => postingWithWhos.postings
  )
  postingWithWhos: PostingWithWho[];
}
