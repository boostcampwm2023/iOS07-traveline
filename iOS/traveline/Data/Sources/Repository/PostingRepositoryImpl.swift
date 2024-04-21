//
//  PostingRepositoryImpl.swift
//  traveline
//
//  Created by 김태현 on 11/30/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Domain

public final class PostingRepositoryImpl: PostingRepository {
    
    private let network: NetworkType
    
    public init(network: NetworkType) {
        self.network = network
    }
    
    public func fetchPostingList(with query: SearchQuery) async throws -> TravelList {
        let postingListResponseDTO = try await network.request(
            endPoint: PostingEndPoint.postingList(query),
            type: PostingListResponseDTO.self
        )
        
        return postingListResponseDTO.map { $0.toDomain() }
    }
    
    public func fetchMyPostingList() async throws -> TravelList {
        let postingListResponseDTO = try await network.request(
            endPoint: PostingEndPoint.myPostingList,
            type: PostingListResponseDTO.self
        )
        
        return postingListResponseDTO.map { $0.toDomain() }
    }
    
    public func fetchRecentKeyword() -> [String]? {
        return UserDefaultsList.recentSearchKeyword
    }
    
    public func saveRecentKeyword(_ keyword: String) {
        if let savedKeywordList = UserDefaultsList.recentSearchKeyword {
            UserDefaultsList.recentSearchKeyword = savedKeywordList + [keyword]
        } else {
            UserDefaultsList.recentSearchKeyword = [keyword]
        }
    }
    
    public func saveRecentKeywordList(_ keywordList: [String]) {
        UserDefaultsList.recentSearchKeyword = keywordList
    }
    
    public func deleteRecentKeyword(_ keyword: String) {
        guard let savedKeywordList = UserDefaultsList.recentSearchKeyword else { return }
        let deletedKeywordList = savedKeywordList.filter({ $0 != keyword })
        UserDefaultsList.recentSearchKeyword = deletedKeywordList
    }
    
    public func fetchPostingTitleList(_ keyword: String) async throws -> SearchKeywordList {
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
    
    public func postPosting(data: TravelRequest) async throws -> TravelID {
        let postPostingsDTO = try await network.request(
            endPoint: PostingEndPoint.createPosting(data.toDTO()),
            type: BaseResponseDTO.self
        )
        
        return TravelID(value: postPostingsDTO.id)
    }
    
    public func fetchTimelineInfo(id: TravelID) async throws -> TimelineTravelInfo {
        let response = try await network.request(
            endPoint: PostingEndPoint.fetchPostingInfo(id.value),
            type: PostingDetailResponseDTO.self
        )
        
        return response.toDomain()
    }
    
    public func putPosting(id: TravelID, data: TravelRequest) async throws -> TravelID {
        let postPostingsDTO = try await network.request(
            endPoint: PostingEndPoint.putPosting(
                id.value,
                data.toDTO()
            ),
            type: BaseResponseDTO.self
        )
        
        return TravelID(value: postPostingsDTO.id)
    }
    
    public func deletePosting(id: TravelID) async throws -> Bool {
        let deletePostingsDTO = try await network.requestWithNoResult(endPoint: PostingEndPoint.deletePosting(id.value))
        
        return deletePostingsDTO
    }
    
    public func postReport(id: TravelID) async throws -> Bool {
        let postReportDTO = try await network.requestWithNoResult(endPoint: PostingEndPoint.postReport(id.value))
        
        return postReportDTO
    }
    
    public func postLike(id: TravelID) async throws -> Bool {
        let postLikeDTO = try await network.requestWithNoResult(endPoint: PostingEndPoint.postLike(id.value))
        
        return postLikeDTO
    }
}
