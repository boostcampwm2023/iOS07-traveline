//
//  TimelineDetailUseCase.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/02.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

protocol TimelineDetailUseCase {
    func fetchTimelineDetail(with id: String) -> AnyPublisher<TimelineDetailInfo, Error>
    func deleteTimeline(id: String) -> AnyPublisher<Bool, Error>
}

final class TimelineDetailUseCaseImpl: TimelineDetailUseCase {
    
    private let repository: TimelineDetailRepository
    
    init(repository: TimelineDetailRepository) {
        self.repository = repository
    }
    
    func fetchTimelineDetail(with id: String) -> AnyPublisher<TimelineDetailInfo, Error> {
        return Future { promise in
            Task { [weak self] in
                guard let self else { return }
                do {
                    let detailInfo = try await self.repository.fetchTimelineDetailInfo(id: id)
                    promise(.success(detailInfo))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func deleteTimeline(id: String) -> AnyPublisher<Bool, Error> {
        return Future { promise in
            Task {
                do {
                    let result = try await self.repository.deleteTimeline(id: id)
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
