//
//  TimelineRepositoryMock.swift
//  traveline
//
//  Created by 김영인 on 2023/12/03.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Domain

final class TimelineRepositoryMock: TimelineRepository {
    
    func fetchTimelineList(id: TravelID, day: Int) async throws -> TimelineCardList {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let mockData = TimelineSample.makeCardList()
        return mockData
    }
}
