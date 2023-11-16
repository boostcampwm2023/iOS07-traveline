import { Injectable } from '@nestjs/common';
import { CreatePostingDto } from './dto/create-posting.dto';
import { UpdatePostingDto } from './dto/update-posting.dto';

@Injectable()
export class PostingsService {
  create(createPostingDto: CreatePostingDto) {
    return 'This action adds a new posting';
  }

  findAll() {
    return `This action returns all postings`;
  }

  findOne(id: number) {
    return `This action returns a #${id} posting`;
  }

  update(id: number, updatePostingDto: UpdatePostingDto) {
    return `This action updates a #${id} posting`;
  }

  remove(id: number) {
    return `This action removes a #${id} posting`;
  }
}
