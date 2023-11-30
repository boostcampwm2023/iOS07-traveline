//
//  PostingRepositoryImpl.swift
//  traveline
//
//  Created by 김태현 on 11/30/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

final class PostingRepositoryImpl: PostingRepository {
    
    private let network: NetworkType
    
    init(network: NetworkType) {
        self.network = network
    }
    
    func fetchPostingList() async throws -> TravelList {
        let postingListResponseDTO = try await network.request(
            endPoint: PostingEndPoint.postingList,
            type: PostingListResponseDTO.self
        )
        
        return postingListResponseDTO.map { $0.toDomain() }
    }
    
}
