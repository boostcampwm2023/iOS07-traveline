//
//  TimelineUseCase.swift
//  traveline
//
//  Created by 김태현 on 11/29/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation
import Combine

protocol TimelineUseCase {
    func fetchTimelineInfo(id: TravelID) -> AnyPublisher<TimelineTravelInfo, Error>
    func fetchTimelineList(id: TravelID, day: Int) -> AnyPublisher<TimelineCardList, Error>
    func calculateDate(from startDate: String, with day: Int) -> String?
    func deleteTravel(id: TravelID) -> AnyPublisher<Bool, Error>
}

final class TimelineUseCaseImpl: TimelineUseCase {

    private let postingRepository: PostingRepository
    private let timelineRepository: TimelineRepository
    
    init(postingRepository: PostingRepository, timelineRepository: TimelineRepository) {
        self.postingRepository = postingRepository
        self.timelineRepository = timelineRepository
    }

    func fetchTimelineInfo(id: TravelID) -> AnyPublisher<TimelineTravelInfo, Error> {
        return Future { promise in
            Task {
                do {
                    let travelInfo = try await self.postingRepository.fetchTimelineInfo(id: id)
                    promise(.success(travelInfo))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchTimelineList(id: TravelID, day: Int) -> AnyPublisher<TimelineCardList, Error> {
        return Future { promise in
            Task {
                do {
                    let timelineList = try await self.timelineRepository.fetchTimelineList(id: id, day: day)
                    promise(.success(timelineList))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func calculateDate(from startDate: String, with day: Int) -> String? {
        guard let date = startDate.toDate(),
              let curDate = Calendar.current.date(byAdding: .day, value: day, to: date) else { return nil }
        
        return curDate.toString(with: "yyyy년 MM월 dd일")

    }
    
    func deleteTravel(id: TravelID) -> AnyPublisher<Bool, Error> {
        return Future { promise in
            Task {
                do {
                    let id = try await self.postingRepository.deletePostings(id: id)
                    promise(.success(true))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
