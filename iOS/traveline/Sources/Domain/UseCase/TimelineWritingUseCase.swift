//
//  TimelineWritingUseCase.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/02.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

protocol TimelineWritingUseCase {
    func requestCreateTimeline(with info: TimelineDetailRequest) -> AnyPublisher<Void, Error>
    func fetchPlaceList(keyword: String, offset: Int) -> AnyPublisher<TimelinePlaceList, Error>
}

final class TimelineWritingUseCaseImpl: TimelineWritingUseCase {
    
    private let repository: TimelineDetailRepository
    
    init(repository: TimelineDetailRepository) {
        self.repository = repository
    }
    
    func requestCreateTimeline(with info: TimelineDetailRequest) -> AnyPublisher<Void, Error> {
        return Future { promise in
            Task {
                do {
                    try await self.repository.createTimelineDetail(with: info)
                    promise(.success(Void()))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchPlaceList(keyword: String, offset: Int) -> AnyPublisher<TimelinePlaceList, Error> {
        if keyword.isEmpty {
            return .just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        return Future { promise in
            Task {
                do {
                    let placeList = try await self.repository.fetchTimelinePlaces(keyword: keyword, offset: offset)
                    promise(.success(placeList))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
}
