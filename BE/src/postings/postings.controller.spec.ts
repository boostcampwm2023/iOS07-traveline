import { Test, TestingModule } from '@nestjs/testing';
import { PostingsController } from './postings.controller';
import { PostingsService } from './postings.service';

describe('PostingsController', () => {
  let controller: PostingsController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [PostingsController],
      providers: [PostingsService],
    }).compile();

    controller = module.get<PostingsController>(PostingsController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
