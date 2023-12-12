//
//  TimelineDetailRepositoryImpl.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/02.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

final class TimelineDetailRepositoryImpl: TimelineDetailRepository {
    
    let network: NetworkType
    
    init(network: NetworkType) {
        self.network = network
    }
    
    func fetchTimelineDetailInfo(id: String) async throws -> TimelineDetailInfo {
        let timelineDetailResponseDTO = try await network.request(
            endPoint: TimelineDetailEndPoint.specificTimeline(id),
            type: TimelineDetailResponseDTO.self
        )
        
        return timelineDetailResponseDTO.toDomain()
    }
    
    func createTimelineDetail(with info: TimelineDetailRequest) async throws {
        try await network.request(
            endPoint: TimelineDetailEndPoint.createTimeline(info.toDTO()),
            type: BaseResponseDTO.self
        )
    }
    
    func fetchTimelinePlaces(keyword: String, offset: Int) async throws -> TimelinePlaceList {
        let timelinePlaceResponseDTO = try await network.request(
            endPoint: TimelineDetailEndPoint.fetchPlaceList(keyword, offset),
            type: TimelinePlaceListResponseDTO.self
        )
        
        return timelinePlaceResponseDTO.toDomain()
    }
    
}
