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
    
    func fetchPostingList(with query: SearchQuery) async throws -> TravelList {
        let postingListResponseDTO = try await network.request(
            endPoint: PostingEndPoint.postingList(query),
            type: PostingListResponseDTO.self
        )
        
        return postingListResponseDTO.map { $0.toDomain() }
    }
    
    func fetchMyPostingList() async throws -> TravelList {
        let postingListResponseDTO = try await network.request(
            endPoint: PostingEndPoint.myPostingList,
            type: PostingListResponseDTO.self
        )
        
        return postingListResponseDTO.map { $0.toDomain() }
    }
    
    func fetchRecentKeyword() -> [String]? {
        return UserDefaultsList.recentSearchKeyword
    }
    
    func saveRecentKeyword(_ keyword: String) {
        if let savedKeywordList = UserDefaultsList.recentSearchKeyword {
            UserDefaultsList.recentSearchKeyword = savedKeywordList + [keyword]
        } else {
            UserDefaultsList.recentSearchKeyword = [keyword]
        }
    }
    
    func saveRecentKeywordList(_ keywordList: [String]) {
        UserDefaultsList.recentSearchKeyword = keywordList
    }
    
    func deleteRecentKeyword(_ keyword: String) {
        guard let savedKeywordList = UserDefaultsList.recentSearchKeyword else { return }
        let deletedKeywordList = savedKeywordList.filter({ $0 != keyword })
        UserDefaultsList.recentSearchKeyword = deletedKeywordList
    }
    
    func fetchPostingTitleList(_ keyword: String) async throws -> SearchKeywordList {
        let postingTitleListResponseDTO = try await network.request(
            endPoint: PostingEndPoint.postingTitleList(keyword),
            type: PostingTitleListResponseDTO.self
        )
        
        return postingTitleListResponseDTO
            .map { SearchKeyword(type: .related, title: $0, searchedKeyword: keyword) }
    }
    
}

// MARK: - Timeline Feature

extension PostingRepositoryImpl {
    
    func postPostings(data: TravelRequest) async throws -> TravelID {
        let postPostingsDTO = try await network.request(
            endPoint: PostingEndPoint.createPosting(data.toDTO()),
            type: BaseResponseDTO.self
        )
        
        return TravelID(value: postPostingsDTO.id)
    }
    
    func fetchTimelineInfo(id: TravelID) async throws -> TimelineTravelInfo {
        let response = try await network.request(
            endPoint: PostingEndPoint.fetchPostingInfo(id.value),
            type: PostingDetailResponseDTO.self
        )
        
        return response.toDomain()
    }
}
