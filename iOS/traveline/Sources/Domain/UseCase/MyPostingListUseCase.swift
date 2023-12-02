//
//  MyPostingListUseCase.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/02.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Combine
import Foundation

protocol MyPostListUseCase {
    func fetchMyPostList() -> AnyPublisher<TravelList, Error>
}

final class MyPostListUseCaseImpl: MyPostListUseCase {
    
    private let repository: PostingRepository
    
    init(repository: PostingRepository) {
        self.repository = repository
    }
    
    func fetchMyPostList() -> AnyPublisher<TravelList, Error> {
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
