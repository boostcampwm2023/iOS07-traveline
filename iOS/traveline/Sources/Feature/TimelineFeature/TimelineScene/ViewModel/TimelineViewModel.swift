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
    case createPostingButtonPressed
}

enum TimelineSideEffect: BaseSideEffect {
    enum TimelineError: LocalizedError {
        case loadFailed
        
        var errorDescription: String {
            switch self {
            case .loadFailed: "서버 통신에 실패했습니다."
            }
        }
    }
    
    case loadTimeline(TimelineTravelInfo)
    case loadTimelineCardList(TimelineCardList)
    case removeRegacyCards(Int)
    case updateCurDate(String)
    case toggleLike
    case showTimelineWriting
    case timelineError(TimelineError)
    case popToTimline
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
    var errorMsg: String?
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
            
        case .createPostingButtonPressed:
            return .just(TimelineSideEffect.showTimelineWriting)
        }
    }
    
    override func reduceState(state: TimelineState, effect: TimelineSideEffect) -> TimelineState {
        var newState = state
        
        switch effect {
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
            
        case .popToTimline:
            newState.timelineWritingInfo = nil
            
        case let .updateCurDate(date):
            newState.date = date
        }
        
        return newState
    }
}

// MARK: - Fetch

private extension TimelineViewModel {
    func fetchTimeline() -> SideEffectPublisher {
        Publishers.MergeMany(
            .just(TimelineSideEffect.popToTimline),
            fetchTimelineCardInfo(currentState.day),
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
            .catch {_ in
                return Just(TimelineSideEffect.timelineError(.loadFailed))
            }
            .eraseToAnyPublisher()
    }
    
    func fetchTimelineCardInfo(_ day: Int) -> SideEffectPublisher {
        return timelineUseCase.fetchTimelineList(id: id, day: day)
            .map { list in
                return TimelineSideEffect.loadTimelineCardList(list)
            }
            .catch {_ in
                return Just(TimelineSideEffect.timelineError(.loadFailed))
            }
            .eraseToAnyPublisher()
    }
}
