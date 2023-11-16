import { PartialType } from '@nestjs/swagger';
import { CreatePostingDto } from './create-posting.dto';

export class UpdatePostingDto extends PartialType(CreatePostingDto) {}
