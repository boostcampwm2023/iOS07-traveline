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
    
}
