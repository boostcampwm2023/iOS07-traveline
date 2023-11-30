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

  @Column({ name: 'coord_x', type: 'double', nullable: true })
  coordX: number;

  @Column({ name: 'coord_y', type: 'double', nullable: true })
  coordY: number;

  @Column({ type: 'date' })
  date: string;

  @Column({ length: 50 })
  place: string;

  @Column({ type: 'char', length: '5' })
  time: string;

  @ManyToOne(() => Posting, (posting) => posting.timelines, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  @JoinColumn({ name: 'posting' })
  posting: Posting;
}
