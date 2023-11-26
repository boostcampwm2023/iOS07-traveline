import { PrimaryGeneratedColumn } from 'typeorm';

export class PostingMapping {
  @PrimaryGeneratedColumn('uuid')
  id: string;
}
