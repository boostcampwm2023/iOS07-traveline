import { Posting } from 'src/postings/entities/posting.entity';
import {
  Entity,
  Column,
  ManyToOne,
  JoinColumn,
  PrimaryGeneratedColumn,
} from 'typeorm';

@Entity()
export class Timeline {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ length: 14 })
  title: string;

  @Column({ type: 'int' })
  day: number;

  @Column({ length: 500 })
  description: string;

  @Column({ length: 255, nullable: true })
  image: string;

  @Column({ type: 'float', nullable: true })
  coord_x: number;

  @Column({ type: 'float', nullable: true })
  coord_y: number;

  @Column({ type: 'date' })
  date: string;

  @Column({ length: 50 })
  place: string;

  @Column({ type: 'time' })
  time: string;

  @ManyToOne(() => Posting, (posting) => posting.timelines, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  @JoinColumn({ name: 'posting' })
  posting: Posting;
}
