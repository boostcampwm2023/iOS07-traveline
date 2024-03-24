//
//  TimelineDetailRepository.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/02.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

public protocol TimelineDetailRepository {
    func fetchTimelineDetailInfo(id: String) async throws -> TimelineDetailInfo
    func createTimelineDetail(with timelineRequest: TimelineDetailRequest) async throws
    func fetchTimelinePlaces(keyword: String, offset: Int) async throws -> TimelinePlaceList
    func putTimeline(id: String, info: TimelineDetailRequest) async throws -> Bool
    func deleteTimeline(id: String) async throws -> Bool
    func fetchTimelineTranslatedInfo(id: String) async throws -> TimelineTranslatedInfo
}
