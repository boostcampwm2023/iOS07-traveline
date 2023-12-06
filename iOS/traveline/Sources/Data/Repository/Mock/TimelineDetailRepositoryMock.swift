//
//  TimelineDetailRepositoryMock.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/02.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

final class TimelineDetailRepositoryMock: TimelineDetailRepository {
    func createTimelineDetail(with timelineRequest: TimelineDetailRequest) async throws -> TimelineDetailInfo {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let mockData = TimelineDetailInfo.sample
        return mockData
    }
    
    func fetchTimelineDetailInfo(id: String) async throws -> TimelineDetailInfo {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let mockData = TimelineDetailInfo.sample
        return mockData
    }
    
}
