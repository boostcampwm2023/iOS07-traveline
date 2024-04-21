//
//  TimelineDetailRepositoryImpl.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/02.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Domain

public final class TimelineDetailRepositoryImpl: TimelineDetailRepository {
    
    let network: NetworkType
    
    public init(network: NetworkType) {
        self.network = network
    }
    
    public func fetchTimelineDetailInfo(id: String) async throws -> TimelineDetailInfo {
        let timelineDetailResponseDTO = try await network.request(
            endPoint: TimelineDetailEndPoint.specificTimeline(id),
            type: TimelineDetailResponseDTO.self
        )
        
        return timelineDetailResponseDTO.toDomain()
    }
    
    public func createTimelineDetail(with info: TimelineDetailRequest) async throws {
        try await network.request(
            endPoint: TimelineDetailEndPoint.createTimeline(info.toDTO()),
            type: BaseResponseDTO.self
        )
    }
    
    public func fetchTimelinePlaces(keyword: String, offset: Int) async throws -> TimelinePlaceList {
        let timelinePlaceResponseDTO = try await network.request(
            endPoint: TimelineDetailEndPoint.fetchPlaceList(keyword, offset),
            type: TimelinePlaceListResponseDTO.self
        )
        
        return timelinePlaceResponseDTO.toDomain()
    }
    
    public func putTimeline(id: String, info: TimelineDetailRequest) async throws -> Bool {
        let putTimelineDTO = try await network.requestWithNoResult(
            endPoint: TimelineDetailEndPoint.putTimeline(id, info.toDTO())
        )
        
        return putTimelineDTO
    }
    
    public func deleteTimeline(id: String) async throws -> Bool {
        let deleteTimelineDTO = try await network.requestWithNoResult(endPoint: TimelineDetailEndPoint.deleteTimeline(id))
        
        return deleteTimelineDTO
    }
    
    public func fetchTimelineTranslatedInfo(id: String) async throws -> TimelineTranslatedInfo {
        let translateTimelineDTO = try await network.request(
            endPoint: TimelineDetailEndPoint.translateTimeline(id),
            type: TimelineTranslatedResponseDTO.self
        )
        
        return translateTimelineDTO.toDomain()
    }
    
}
