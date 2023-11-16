import { Posting } from 'src/postings/entities/posting.entity';
import { Entity, PrimaryColumn, Column, ManyToOne, JoinColumn } from 'typeorm';

@Entity()
export class Timeline {
  @PrimaryColumn({ type: 'char', length: 36 })
  id: string;

  @Column({ type: 'varchar', length: 14 })
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
  date: Date;

  @Column({ length: 50 })
  place: string;

  @Column({ type: 'timestamp' })
  time: Date;

  @Column({ type: 'char', length: 36 })
  posting: string;

  @ManyToOne(() => Posting, (posting) => posting.timelines, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  @JoinColumn({ name: 'posting', referencedColumnName: 'id' })
  postings: Posting;
}
