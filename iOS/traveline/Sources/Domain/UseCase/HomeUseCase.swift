//
//  HomeUseCase.swift
//  traveline
//
//  Created by 김태현 on 11/30/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

protocol HomeUseCase {
    func fetchHomeList() -> AnyPublisher<TravelList, Error>
    func fetchRecentKeyword() -> AnyPublisher<SearchKeywordList, Never>
    func saveRecentKeyword(_ keyword: String)
}

final class HomeUseCaseImpl: HomeUseCase {
    
    private let repository: PostingRepository
    
    init(repository: PostingRepository) {
        self.repository = repository
    }
    
    func fetchHomeList() -> AnyPublisher<TravelList, Error> {
        return Future { promise in
            Task { [weak self] in
                guard let self else { return }
                do {
                    let travelList = try await self.repository.fetchPostingList()
                    promise(.success(travelList))
                } catch {
                    promise(.failure(error))
                }
            }
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
        repository.saveRecentKeyword(keyword)
    }
    
}
