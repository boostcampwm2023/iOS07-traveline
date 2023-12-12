//
//  TimelineDetailRepositoryMock.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/02.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

final class TimelineDetailRepositoryMock: TimelineDetailRepository {
    
    func createTimelineDetail(with timelineRequest: TimelineDetailRequest) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
    
    func fetchTimelineDetailInfo(id: String) async throws -> TimelineDetailInfo {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let mockData = TimelineDetailInfo.sample
        return mockData
    }
    
    func fetchTimelinePlaces(keyword: String, offset: Int) async throws -> TimelinePlaceList {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let mockData = [TimelinePlace.init(title: "", address: "", latitude: 0, longitude: 0)]
        return mockData
    }
    
    func putTimeline(id: String, info: TimelineDetailRequest) async throws -> Bool {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        return true
    }
    
    func deleteTimeline(id: String) async throws -> Bool {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        return true
    }
}
