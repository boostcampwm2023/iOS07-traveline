//
//  PostingRepositoryMock.swift
//  traveline
//
//  Created by 김태현 on 11/30/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

final class PostingRepositoryMock: PostingRepository {
    
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
