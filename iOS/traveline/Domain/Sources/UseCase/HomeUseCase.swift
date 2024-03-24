//
//  HomeUseCase.swift
//  traveline
//
//  Created by 김태현 on 11/30/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

import Core

public protocol HomeUseCase {
    func fetchSearchList(with query: SearchQuery) -> AnyPublisher<TravelList, Error>
    func fetchRecentKeyword() -> AnyPublisher<SearchKeywordList, Never>
    func saveRecentKeyword(_ keyword: String)
    func deleteRecentKeyword(_ keyword: String) -> AnyPublisher<SearchKeywordList, Never>
    func fetchRelatedKeyword(_ keyword: String) -> AnyPublisher<SearchKeywordList, Error>
}

final class HomeUseCaseImpl: HomeUseCase {
    
    private let repository: PostingRepository
    
    init(repository: PostingRepository) {
        self.repository = repository
    }
    
    func fetchSearchList(with query: SearchQuery) -> AnyPublisher<TravelList, Error> {
        return Future {
            let travelList = try await self.repository.fetchPostingList(with: query)
            return travelList
        }.eraseToAnyPublisher()
    }
    
    func fetchRecentKeyword() -> AnyPublisher<SearchKeywordList, Never> {
        if let keywordList = repository.fetchRecentKeyword()?.reversed() {
            let recentKeywordList = keywordList.map { SearchKeyword(type: .recent, title: $0) }
            return .just(recentKeywordList)
        }
        return .just([])
    }
    
    func saveRecentKeyword(_ keyword: String) {
        if let savedKeywordList = repository.fetchRecentKeyword() {
            let deDuplicationList = savedKeywordList.filter({ $0 != keyword })
            
            if deDuplicationList.count < 15 {
                repository.saveRecentKeywordList(deDuplicationList + [keyword])
            } else {
                let removeOldestKeyword = deDuplicationList.dropFirst()
                repository.saveRecentKeywordList(removeOldestKeyword + [keyword])
            }
        } else {
            repository.saveRecentKeyword(keyword)
        }
    }
    
    func deleteRecentKeyword(_ keyword: String) -> AnyPublisher<SearchKeywordList, Never> {
        repository.deleteRecentKeyword(keyword)
        return fetchRecentKeyword()
    }
    
    func fetchRelatedKeyword(_ keyword: String) -> AnyPublisher<SearchKeywordList, Error> {
        return Future {
            let relatedKeyword = try await self.repository.fetchPostingTitleList(keyword)
            return relatedKeyword
        }.eraseToAnyPublisher()
    }
    
}
