//
//  TimelineRepositoryImpl.swift
//  traveline
//
//  Created by 김태현 on 11/29/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

final class TimelineRepositoryImpl: TimelineRepository {
    
    private let network: NetworkType
    
    init(network: NetworkType) {
        self.network = network
    }
    
    func fetchTravelInfo(id: String) async throws -> TimelineTravelInfo {
        // EndPoint 만들어주고
        let postingResponseDTO = try await network.request(
            endPoint: PostingEndPoint.specificPosting,
            type: PostingResponseDTO.self
        )
        
        // 받아온 데이터 Domain으로 변경 (Data -> Domain 역할)
        return postingResponseDTO.toDomain()
    }
    
}
