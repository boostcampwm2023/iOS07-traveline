//
//  TimelineViewModel.swift
//  traveline
//
//  Created by 김태현 on 11/28/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

enum TimelineAction: BaseAction {
    case viewWillAppear
    case enterToTimeline
    case fetchTimelineCard(Int)
    case changeDay(Int)
    case likeButtonPressed
    case createPostingButtonPressed
    case editTravel
    case deleteTravel
    case reportTravel
}

enum TimelineSideEffect: BaseSideEffect {
    enum TimelineError: LocalizedError {
        case loadFailed
        case deleteFailed
        case reportFailed
        case likeFailed
        
        var errorDescription: String {
            switch self {
            case .loadFailed: "서버 통신에 실패했습니다."
            case .deleteFailed: "여행 삭제에 실패했습니다."
            case .reportFailed: "여행 신고에 실패했습니다."
            case .likeFailed: "여행 좋아요에 실패했습니다."
            }
        }
    }
    
    case loadTimeline(TimelineTravelInfo)
    case loadTimelineCardList(TimelineCardList)
    case removeRegacyCards(Int)
    case updateCurDate(String)
    case toggleLike
    case showTimelineWriting
    case showTimelineEditing
    case popToTimeline
    case popToHome
    case timelineError(TimelineError)
    case resetState
    case none
}

struct TimelineState: BaseState {
    struct TimelineWritingInfo: Hashable {
        let id: TravelID
        var date: String
        var day: Int
    }
    
    var travelInfo: TimelineTravelInfo = .empty
    var timelineCardList: TimelineCardList = []
    var isOwner: Bool = false
    var day: Int = 1
    var date: String?
    var timelineWritingInfo: TimelineWritingInfo?
    var isEdit: Bool = false
    var deleteCompleted: Bool = false
    var errorMsg: String?
}

final class TimelineViewModel: BaseViewModel<TimelineAction, TimelineSideEffect, TimelineState> {
    
    private(set) var id: TravelID
    private let timelineUseCase: TimelineUseCase
    
    init(
        id: TravelID,
        fetchTravelInfoUseCase: TimelineUseCase
    ) {
        self.id = id
        self.timelineUseCase = fetchTravelInfoUseCase
    }
    
    // MARK: - Transform
    
    override func transform(action: TimelineAction) -> SideEffectPublisher {
        switch action {
        case .viewWillAppear:
            return .just(.resetState)
            
        case .enterToTimeline:
            return fetchTimeline()
            
        case let .fetchTimelineCard(day):
            return fetchTimelineCardInfo(day)
            
        case let .changeDay(day):
            return fetchTimelineCard(day)
            
        case .likeButtonPressed:
            return Publishers.Merge(
                Just(.toggleLike),
                likeTravel()
            )
            .eraseToAnyPublisher()
            
        case .createPostingButtonPressed:
            return .just(.showTimelineWriting)
            
        case .editTravel:
            return .just(.showTimelineEditing)
            
        case .deleteTravel:
            return deleteTravel()
            
        case .reportTravel:
            return reportTravel()
        }
    }
    
    override func reduceState(state: TimelineState, effect: TimelineSideEffect) -> TimelineState {
        var newState = state
        
        switch effect {
        case .none:
            return newState
            
        case .resetState:
            newState.isEdit = false
            newState.deleteCompleted = false
            newState.timelineWritingInfo = nil
            
        case let .loadTimeline(travelInfo):
            newState.travelInfo = travelInfo
            newState.isOwner = travelInfo.isOwner
            newState.date = timelineUseCase.calculateDate(from: travelInfo.startDate, with: state.day)
            
        case let .loadTimelineCardList(timelineCardList):
            newState.timelineCardList = timelineCardList
            
        case let .removeRegacyCards(day):
            newState.day = day
            newState.timelineCardList.removeAll()
            sendAction(.fetchTimelineCard(day))
            
        case .toggleLike:
            newState.travelInfo.isLiked.toggle()
            
        case .showTimelineWriting:
            guard let date = state.date else { return newState }
            
            newState.timelineWritingInfo = .init(
                id: id,
                date: date,
                day: state.day
            )
            
        case let .timelineError(error):
            break
            
        case .popToTimeline:
            newState.timelineWritingInfo = nil
            
        case .popToHome:
            newState.deleteCompleted = true
            
        case let .updateCurDate(date):
            newState.date = date
            
        case .showTimelineEditing:
            newState.isEdit = true
        }
        
        return newState
    }
}

// MARK: - Fetch

private extension TimelineViewModel {
    func fetchTimeline() -> SideEffectPublisher {
        Publishers.MergeMany(
            .just(.popToTimeline),
            fetchTimelineCardInfo(currentState.day),
            fetchTravelInfo()
        ).eraseToAnyPublisher()
    }
    
    func fetchTimelineCard(_ day: Int) -> SideEffectPublisher {
        return .just(.removeRegacyCards(day))
    }
    
    func fetchTravelInfo() -> SideEffectPublisher {
        return timelineUseCase.fetchTimelineInfo(id: id)
            .map { travelInfo in
                return .loadTimeline(travelInfo)
            }
            .catch {_ in
                return Just(.timelineError(.loadFailed))
            }
            .eraseToAnyPublisher()
    }
    
    func fetchTimelineCardInfo(_ day: Int) -> SideEffectPublisher {
        return timelineUseCase.fetchTimelineList(id: id, day: day)
            .map { list in
                return .loadTimelineCardList(list)
            }
            .catch { _ in
                return Just(.timelineError(.loadFailed))
            }
            .eraseToAnyPublisher()
    }
    
    func deleteTravel() -> SideEffectPublisher {
        return timelineUseCase.deleteTravel(id: id)
            .map { _ in
                return .popToHome
            }
            .catch { _ in
                return Just(.timelineError(.deleteFailed))
            }
            .eraseToAnyPublisher()
    }
    
    func reportTravel() -> SideEffectPublisher {
        return timelineUseCase.reportTravel(id: id)
            .map { _ in
                return .popToHome
            }
            .catch { _ in
                return Just(.timelineError(.reportFailed))
            }
            .eraseToAnyPublisher()
    }
    
    func likeTravel() -> SideEffectPublisher {
        return timelineUseCase.likeTravel(id: id)
            .map { _ in
                return .none
            }
            .catch { _ in
                return Just(.timelineError(.likeFailed))
            }
            .eraseToAnyPublisher()
    }
    
}
