//
//  TravelUseCase.swift
//  traveline
//
//  Created by 김영인 on 2023/11/30.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

enum TitleValidation {
    case valid
    case invalidate
}

protocol TravelUseCase {
    func validate(title: String) -> TitleValidation
    func createTravel(data: TravelRequest) -> AnyPublisher<TravelID, Error>
}

final class TravelUseCaseImpl: TravelUseCase {
    
    private let repository: PostingRepository
    
    init(repository: PostingRepository) {
        self.repository = repository
    }
    
    func validate(title: String) -> TitleValidation {
        return 1...14 ~= title.count ? .valid : .invalidate
    }
    
    func createTravel(data: TravelRequest) -> AnyPublisher<TravelID, Error> {
        return Future { promise in
            Task {
                do {
                    let id = try await self.repository.postPostings(data: data)
                    promise(.success(id))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
}
