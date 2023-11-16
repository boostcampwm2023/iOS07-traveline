import { Test, TestingModule } from '@nestjs/testing';
import { TimelinesService } from './timelines.service';

describe('TimelinesService', () => {
  let service: TimelinesService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [TimelinesService],
    }).compile();

    service = module.get<TimelinesService>(TimelinesService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
