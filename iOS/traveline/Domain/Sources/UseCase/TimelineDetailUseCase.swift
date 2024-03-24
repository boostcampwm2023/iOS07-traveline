//
//  TimelineDetailUseCase.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/02.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

public protocol TimelineDetailUseCase {
    func fetchTimelineDetail(with id: String) -> AnyPublisher<TimelineDetailInfo, Error>
    func deleteTimeline(id: String) -> AnyPublisher<Bool, Error>
    func fetchTranslateTimelineDetail(with id: String) -> AnyPublisher<TimelineTranslatedInfo, Error>
}

final class TimelineDetailUseCaseImpl: TimelineDetailUseCase {
    
    private let repository: TimelineDetailRepository
    
    init(repository: TimelineDetailRepository) {
        self.repository = repository
    }
    
    func fetchTimelineDetail(with id: String) -> AnyPublisher<TimelineDetailInfo, Error> {
        return Future {
            let detailInfo = try await self.repository.fetchTimelineDetailInfo(id: id)
            return detailInfo
        }.eraseToAnyPublisher()
    }
    
    func deleteTimeline(id: String) -> AnyPublisher<Bool, Error> {
        return Future {
            let result = try await self.repository.deleteTimeline(id: id)
            return result
        }.eraseToAnyPublisher()
    }
    
    func fetchTranslateTimelineDetail(with id: String) -> AnyPublisher<TimelineTranslatedInfo, Error> {
        return Future {
            let translatedInfo = try await self.repository.fetchTimelineTranslatedInfo(id: id)
            return translatedInfo
        }.eraseToAnyPublisher()
    }
}
