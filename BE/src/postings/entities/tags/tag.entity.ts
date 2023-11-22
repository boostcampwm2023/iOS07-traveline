import { Column, PrimaryGeneratedColumn } from 'typeorm';

export class Tag {
  @PrimaryGeneratedColumn('increment')
  id: number;

  @Column({ length: 14 })
  name: string;
}
