//
//  MyPostingListUseCase.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/02.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

public protocol MyPostListUseCase {
    func fetchMyPostList() -> AnyPublisher<TravelList, Error>
}

final class MyPostListUseCaseImpl: MyPostListUseCase {
    
    private let repository: PostingRepository
    
    init(repository: PostingRepository) {
        self.repository = repository
    }
    
    func fetchMyPostList() -> AnyPublisher<TravelList, Error> {
        return Future {
            let travelList = try await self.repository.fetchMyPostingList()
            return travelList
        }.eraseToAnyPublisher()
    }
    
}
