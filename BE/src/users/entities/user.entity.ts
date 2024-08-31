import { Liked } from 'src/postings/entities/liked.entity';
import { Posting } from 'src/postings/entities/posting.entity';
import { Report } from 'src/postings/entities/report.entity';
import { Block } from './block.entity';
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

  @Column({ length: 35, unique: true })
  email: string;

  @Column({ type: 'json', name: 'allowed_ip' })
  allowedIp: string[];

  @Column({ type: 'json', name: 'banned_ip', nullable: true })
  bannedIp: string[];

  @OneToMany(() => Liked, (liked) => liked.users)
  likeds: Liked[];

  @OneToMany(() => Report, (report) => report.reporters)
  reports: Report[];

  @OneToMany(() => Posting, (posting) => posting.writer)
  postings: Posting[];

  @ManyToOne(() => SocialLogin, (socialLogin) => socialLogin.users)
  @JoinColumn({ name: 'social_type', referencedColumnName: 'id' })
  socials: SocialLogin;

  @OneToMany(() => Block, (block) => block.blocker)
  blockers: Block[];

  @OneToMany(() => Block, (block) => block.blocked)
  blockeds: Block[];
}
