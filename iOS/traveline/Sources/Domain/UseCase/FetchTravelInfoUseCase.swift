//
//  FetchTravelInfoUseCase.swift
//  traveline
//
//  Created by 김태현 on 11/29/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation
import Combine

protocol FetchTravelInfoUseCase {
    func execute(id: String) -> AnyPublisher<TimelineTravelInfo, Error>
}

final class FetchTravelInfoUseCaseImpl: FetchTravelInfoUseCase {
    
    private let repository: TimelineRepository
    
    init(repository: TimelineRepository) {
        self.repository = repository
    }

    func execute(id: String) -> AnyPublisher<TimelineTravelInfo, Error> {
        return Future { promise in
            Task {
                do {
                    let travelInfo = try await self.repository.fetchTravelInfo(id: id)
                    promise(.success(travelInfo))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
}
