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
    case enterToTimeline
    case fetchTimelineCard(Int)
    case changeDay(Int)
    case likeButtonPressed
}

enum TimelineSideEffect: BaseSideEffect {
    case loadTimeline(TimelineTravelInfo)
    case loadTimelineCardList(TimelineCardList)
    case removeRegacyCards(Int)
    case toggleLike
    case loadFailed(Error)
}

struct TimelineState: BaseState {
    var travelInfo: TimelineTravelInfo = .empty
    var timelineCardList: TimelineCardList = []
    var period: Int = 0
    var isOwner: Bool = false
}

final class TimelineViewModel: BaseViewModel<TimelineAction, TimelineSideEffect, TimelineState> {
    
    private let id: TravelID
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
        case .enterToTimeline:
            return fetchTimeline()
            
        case let .fetchTimelineCard(day):
            return fetchTimelineCardInfo(day)
            
        case let .changeDay(day):
            return fetchTimelineCard(day)
            
        case .likeButtonPressed:
            return .just(TimelineSideEffect.toggleLike)
        }
    }
    
    override func reduceState(state: TimelineState, effect: TimelineSideEffect) -> TimelineState {
        var newState = state
        
        switch effect {
        case let .loadTimeline(travelInfo):
            newState.travelInfo = travelInfo
            newState.isOwner = travelInfo.isOwner
            
        case let .loadTimelineCardList(timelineCardList):
            newState.timelineCardList = timelineCardList
            
        case let .removeRegacyCards(day):
            newState.timelineCardList.removeAll()
            sendAction(.fetchTimelineCard(day))
            
        case .toggleLike:
            newState.travelInfo.isLiked.toggle()
            
        case .loadFailed:
            // TODO: - 서버 통신 실패 시 state 처리
            break
        }
        
        return newState
    }
}

// MARK: - Fetch

private extension TimelineViewModel {
    func fetchTimeline() -> SideEffectPublisher {
        Publishers.Merge(
            fetchTimelineCardInfo(1),
            fetchTravelInfo()
        ).eraseToAnyPublisher()
    }
    
    func fetchTimelineCard(_ day: Int) -> SideEffectPublisher {
        return .just(TimelineSideEffect.removeRegacyCards(day))
    }
    
    func fetchTravelInfo() -> SideEffectPublisher {
        return timelineUseCase.fetchTimelineInfo(id: id)
            .map { travelInfo in
                return TimelineSideEffect.loadTimeline(travelInfo)
            }
            .catch { error in
                return Just(TimelineSideEffect.loadFailed(error))
            }
            .eraseToAnyPublisher()
    }
    
    func fetchTimelineCardInfo(_ day: Int) -> SideEffectPublisher {
        return timelineUseCase.fetchTimelineList(id: id, day: day)
            .map { list in
                return TimelineSideEffect.loadTimelineCardList(list)
            }
            .catch { error in
                return Just(TimelineSideEffect.loadFailed(error))
            }
            .eraseToAnyPublisher()
    }
}
