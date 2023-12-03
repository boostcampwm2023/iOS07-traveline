//
//  TravelUseCase.swift
//  traveline
//
//  Created by 김영인 on 2023/11/30.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

protocol TravelUseCase {
    func createTravel(data: TravelRequest) -> AnyPublisher<TravelID, Error>
}

final class TravelUseCaseImpl: TravelUseCase {
    
    private let repository: TravelRepository
    
    init(repository: TravelRepository) {
        self.repository = repository
    }
    
    func createTravel(data: TravelRequest) -> AnyPublisher<TravelID, Error> {
        return Future { promise in
            Task {
                do {
                    let id = try await self.repository.postTravel(data: data)
                    promise(.success(id))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
}
