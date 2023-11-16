import { Test, TestingModule } from '@nestjs/testing';
import { TimelinesController } from './timelines.controller';
import { TimelinesService } from './timelines.service';

describe('TimelinesController', () => {
  let controller: TimelinesController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [TimelinesController],
      providers: [TimelinesService],
    }).compile();

    controller = module.get<TimelinesController>(TimelinesController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
