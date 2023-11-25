import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
  RelationId,
} from 'typeorm';
import { Liked } from './liked.entity';
import { Report } from './report.entity';
import { User } from '../../users/entities/user.entity';
import { Timeline } from '../../timelines/entities/timeline.entity';
import { PostingTheme } from './mappings/posting-theme.entity';
import { PostingWithWho } from './mappings/posting-with-who.entity';
import { Budget } from './tags/budget.entity';
import { Season } from './tags/season.entity';
import { Vehicle } from './tags/vehicle.entity';
import { Period } from './tags/period.entity';
import { Location } from './tags/location.entity';
import { Headcount } from './tags/headcount.entity';

@Entity()
export class Posting {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User, (user) => user.postings, {
    onDelete: 'CASCADE',
    nullable: true,
  })
  @JoinColumn({ name: 'writer' })
  writer: User;

  @Column({ length: 14 })
  title: string;

  @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
  createdAt: Date;

  @Column({ length: 255, nullable: true, default: null })
  thumbnail: string;

  @RelationId((posting: Posting) => posting.likeds)
  liked: { user: string; posting: string }[];

  @Column({ name: 'start_date', type: 'date' })
  startDate: Date;

  @Column({ name: 'end_date', type: 'date' })
  endDate: Date;

  @Column({ type: 'int' })
  days: number;

  @ManyToOne(() => Period, (period) => period.postings, { nullable: false })
  @JoinColumn({ name: 'period' })
  period: Period;

  @ManyToOne(() => Headcount, (headcount) => headcount.postings)
  @JoinColumn({ name: 'headcount' })
  headcount: Headcount;

  @ManyToOne(() => Budget, (budget) => budget.postings)
  @JoinColumn({ name: 'budget' })
  budget: Budget;

  @ManyToOne(() => Location, (location) => location.postings, {
    nullable: false,
  })
  @JoinColumn({ name: 'location' })
  location: Location;

  @ManyToOne(() => Season, (season) => season.postings, { nullable: false })
  @JoinColumn({ name: 'season' })
  season: Season;

  @ManyToOne(() => Vehicle, (vehicle) => vehicle.postings)
  @JoinColumn({ name: 'vehicle' })
  vehicle: Vehicle;

  @RelationId((posting: Posting) => posting.reports)
  report: { reporter: string; posting: string }[];

  @OneToMany(() => Timeline, (timeline) => timeline.postings)
  timelines: Timeline[];

  @OneToMany(() => Liked, (liked) => liked.postings)
  likeds: Liked[];

  @OneToMany(() => Report, (report) => report.postings)
  reports: Report[];

  @OneToMany(() => PostingTheme, (postingTheme) => postingTheme.posting)
  postingThemes: PostingTheme[];

  @OneToMany(() => PostingWithWho, (postingWithWhos) => postingWithWhos.posting)
  postingWithWhos: PostingWithWho[];
}
