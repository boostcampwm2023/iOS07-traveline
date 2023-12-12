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
    func putTimeline(id: String, info: TimelineDetailRequest) -> AnyPublisher<Bool, Error>
    func toTimelineDetailRequest(from info: TimelineDetailInfo) -> TimelineDetailRequest
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
    
    func putTimeline(id: String, info: TimelineDetailRequest) -> AnyPublisher<Bool, Error> {
        return Future { promise in
            Task {
                do {
                    let result = try await self.repository.putTimeline(id: id, info: info)
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func toTimelineDetailRequest(from info: TimelineDetailInfo) -> TimelineDetailRequest {
        return .init(
            title: info.title,
            day: info.day,
            time: info.time,
            date: info.date,
            place: .init(
                title: info.location,
                address: Literal.empty,
                latitude: info.coordY ?? 0.0,
                longitude: info.coordX ?? 0.0
            ),
            content: info.description,
            posting: info.postingID
        )
    }
}
