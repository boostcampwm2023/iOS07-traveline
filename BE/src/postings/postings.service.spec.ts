import { Test, TestingModule } from '@nestjs/testing';
import { PostingsService } from './postings.service';

describe('PostingsService', () => {
  let service: PostingsService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [PostingsService],
    }).compile();

    service = module.get<PostingsService>(PostingsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
