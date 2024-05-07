//
//  TimelineUseCase.swift
//  traveline
//
//  Created by 김태현 on 11/29/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation
import Combine

public protocol TimelineUseCase {
    func fetchTimelineInfo(id: TravelID) -> AnyPublisher<TimelineTravelInfo, Error>
    func fetchTimelineList(id: TravelID, day: Int) -> AnyPublisher<TimelineCardList, Error>
    func calculateDate(from startDate: String, with day: Int) -> String?
    func deleteTravel(id: TravelID) -> AnyPublisher<Bool, Error>
    func reportTravel(id: TravelID) -> AnyPublisher<Bool, Error>
    func likeTravel(id: TravelID) -> AnyPublisher<Bool, Error>
}

public final class TimelineUseCaseImpl: TimelineUseCase {

    private let postingRepository: PostingRepository
    private let timelineRepository: TimelineRepository
    
    public init(postingRepository: PostingRepository, timelineRepository: TimelineRepository) {
        self.postingRepository = postingRepository
        self.timelineRepository = timelineRepository
    }

    public func fetchTimelineInfo(id: TravelID) -> AnyPublisher<TimelineTravelInfo, Error> {
        return Future {
            let travelInfo = try await self.postingRepository.fetchTimelineInfo(id: id)
            return travelInfo
        }.eraseToAnyPublisher()
    }
    
    public func fetchTimelineList(id: TravelID, day: Int) -> AnyPublisher<TimelineCardList, Error> {
        return Future {
            let timelineList = try await self.timelineRepository.fetchTimelineList(id: id, day: day)
            return timelineList
        }.eraseToAnyPublisher()
    }
    
    public func calculateDate(from startDate: String, with day: Int) -> String? {
        guard let date = startDate.toDate(),
              let curDate = Calendar.current.date(byAdding: .day, value: day, to: date) else { return nil }
        
        return curDate.toString(with: "yyyy년 MM월 dd일")

    }
    
    public func deleteTravel(id: TravelID) -> AnyPublisher<Bool, Error> {
        return Future {
            let result = try await self.postingRepository.deletePosting(id: id)
            return result
        }.eraseToAnyPublisher()
    }
    
    public func reportTravel(id: TravelID) -> AnyPublisher<Bool, Error> {
        return Future {
            let result = try await self.postingRepository.postReport(id: id)
            return result
        }.eraseToAnyPublisher()
    }
    
    public func likeTravel(id: TravelID) -> AnyPublisher<Bool, Error> {
        return Future {
            let result = try await self.postingRepository.postLike(id: id)
            return result
        }.eraseToAnyPublisher()
    }
    
}
