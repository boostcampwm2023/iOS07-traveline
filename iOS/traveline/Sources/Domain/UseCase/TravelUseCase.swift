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
    func toEditable(info: TimelineTravelInfo) -> TravelEditableInfo
    func validate(title: String) -> TitleValidation
    func createTravel(data: TravelRequest) -> AnyPublisher<TravelID, Error>
    func putTravel(id: TravelID, data: TravelRequest) -> AnyPublisher<TravelID, Error>
}

final class TravelUseCaseImpl: TravelUseCase {
    
    private let repository: PostingRepository
    
    init(repository: PostingRepository) {
        self.repository = repository
    }
    
    func toEditable(info: TimelineTravelInfo) -> TravelEditableInfo {
        return .init(
            travelTitle: info.travelTitle,
            region: info.tags.filter { $0.type == .region }.first?.toRegionFilter(),
            startDate: info.startDate.toDate(),
            endDate: info.endDate.toDate(),
            tags: info.tags.filter { !$0.type.isBasic }
        )
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
    
    func putTravel(id: TravelID, data: TravelRequest) -> AnyPublisher<TravelID, Error> {
        return Future { promise in
            Task {
                do {
                    let id = try await self.repository.putPostings(
                        id: id,
                        data: data
                    )
                    promise(.success(id))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
}
