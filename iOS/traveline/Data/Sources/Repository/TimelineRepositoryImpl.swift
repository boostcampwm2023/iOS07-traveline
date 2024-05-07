//
//  TimelineRepositoryImpl.swift
//  traveline
//
//  Created by 김태현 on 11/29/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Domain

public final class TimelineRepositoryImpl: TimelineRepository {
    
    private let network: NetworkType
    
    public init(network: NetworkType) {
        self.network = network
    }
    
    public func fetchTimelineList(id: TravelID, day: Int) async throws -> TimelineCardList {
        let request = FetchTimelineRequestDTO(
            id: id.value,
            day: day
        )
        let response = try await network.request(
            endPoint: TimelineEndPoint.fetchTimelines(request),
            type: TimelineListResponseDTO.self
        )
        
        return response.toDomain()
    }
}
