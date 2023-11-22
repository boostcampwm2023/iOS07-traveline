import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { User } from './user.entity';

@Entity('social_login')
export class SocialLogin {
  @PrimaryGeneratedColumn('increment')
  id: number;

  @Column({ length: 10, unique: true })
  name: string;

  @OneToMany(() => User, (user) => user.socials)
  users: User[];
}
