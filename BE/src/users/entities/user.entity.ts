import { Liked } from 'src/postings/entities/liked.entity';
import { Posting } from 'src/postings/entities/posting.entity';
import { Report } from 'src/postings/entities/report.entity';
import {
  Entity,
  Column,
  OneToMany,
  ManyToOne,
  JoinColumn,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { SocialLogin } from './social-login.entity';

@Entity()
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ length: 14, unique: true })
  name: string;

  @Column({ length: 255, nullable: true })
  avatar: string;

  @Column({ length: 255, name: 'resource_id' })
  resourceId: string;

  @Column({ type: 'int', name: 'social_type' })
  socialType: number;

  @OneToMany(() => Liked, (liked) => liked.users)
  likeds: Liked[];

  @OneToMany(() => Report, (report) => report.reporters)
  reports: Report[];

  @OneToMany(() => Posting, (posting) => posting.writer)
  postings: Posting[];

  @ManyToOne(() => SocialLogin, (socialLogin) => socialLogin.users)
  @JoinColumn({ name: 'social_type', referencedColumnName: 'id' })
  socials: SocialLogin;
}
