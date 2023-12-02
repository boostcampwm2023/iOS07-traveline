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
    
    func fetchRecentKeyword() -> [String]? {
        return UserDefaultsList.recentSearchKeyword
    }
    
    func saveRecentKeyword(_ keyword: String) {
        if let savedKeywordList = UserDefaultsList.recentSearchKeyword {
            let deDuplicationList = savedKeywordList.filter({ $0 != keyword })
            if deDuplicationList.count < 15 {
                UserDefaultsList.recentSearchKeyword = deDuplicationList + [keyword]
            } else {
                let removeOldestKeyword = deDuplicationList.dropFirst()
                UserDefaultsList.recentSearchKeyword = removeOldestKeyword + [keyword]
            }
        } else {
            UserDefaultsList.recentSearchKeyword = [keyword]
        }
    }
    
}
