//
//  TravelRepositoryImpl.swift
//  traveline
//
//  Created by 김영인 on 2023/11/30.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

final class TravelRepositoryImpl: TravelRepository {
    
    private let network: NetworkType
    
    init(network: NetworkType) {
        self.network = network
    }
    
    func postTravel(data: TravelRequest) async throws -> TravelID {
        let postPostingsDTO = try await network.request(
            endPoint: PostingEndPoint.createPosting(data.toDTO()),
            type: PostPostingsDTO.self
        )
        
        return TravelID(value: postPostingsDTO.id)
    }
    
}
