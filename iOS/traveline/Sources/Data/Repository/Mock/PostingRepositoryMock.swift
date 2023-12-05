//
//  PostingRepositoryMock.swift
//  traveline
//
//  Created by 김태현 on 11/30/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

final class PostingRepositoryMock: PostingRepository {
    func fetchMyPostingList() async throws -> TravelList {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let mockData = TravelListSample.make()
        return mockData
    }
    
    func fetchPostingList() async throws -> TravelList {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let mockData = TravelListSample.make()
        return mockData
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
    
}

// MARK: - Timeline Feature

extension PostingRepositoryMock {
    
    func postPostings(data: TravelRequest) async throws -> TravelID {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        return TravelID(value: "id")
    }
    
    func fetchTimelineInfo(id: TravelID) async throws -> TimelineTravelInfo {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let mockData = TimelineSample.makeTravelInfo()
        return mockData
    }
}
