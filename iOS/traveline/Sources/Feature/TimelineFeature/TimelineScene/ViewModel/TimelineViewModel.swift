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
    case fetchTimelineCard
    case changeDay(Int)
    case likeButtonPressed
}

enum TimelineSideEffect: BaseSideEffect {
    case loadTimeline(TimelineTravelInfo)
    case loadTimelineCardList(TimelineCardList)
    case removeRegacyCards
    case toggleLike
}

struct TimelineState: BaseState {
    var travelInfo: TimelineTravelInfo = .init(
        travelTitle: Literal.empty,
        startDate: Literal.empty,
        endDate: Literal.empty,
        isLiked: false,
        tags: .init()
    )
    var timelineCardList: TimelineCardList = []
    var period: Int = 0
    var isOwner: Bool = false
}

final class TimelineViewModel: BaseViewModel<TimelineAction, TimelineSideEffect, TimelineState> {
    override func transform(action: TimelineAction) -> SideEffectPublisher {
        switch action {
        case .enterToTimeline:
            fetchTimeline()
            
        case .fetchTimelineCard:
            fetchTimelineCardInfo()
            
        case .changeDay(_):
            fetchTimelineCard()
            
        case .likeButtonPressed:
            .just(TimelineSideEffect.toggleLike)
        }
    }
    
    override func reduceState(state: TimelineState, effect: TimelineSideEffect) -> TimelineState {
        var newState = state
        
        switch effect {
        case let .loadTimeline(travelInfo):
            newState.travelInfo = travelInfo
            // 본인 게시물인지
            newState.isOwner = false
            
        case let .loadTimelineCardList(timelineCardList):
            newState.timelineCardList = timelineCardList
            
        case .removeRegacyCards:
            newState.timelineCardList.removeAll()
            sendAction(.fetchTimelineCard)
            
        case .toggleLike:
            newState.travelInfo.isLiked.toggle()
        }
        
        return newState
    }
}

// MARK: - Fetch

private extension TimelineViewModel {
    func fetchTimeline() -> SideEffectPublisher {
        Publishers.Merge(
            fetchTimelineCardInfo(),
            fetchTimelineTravelInfo()
        ).eraseToAnyPublisher()
    }
    
    func fetchTimelineCard() -> SideEffectPublisher {
        return .just(TimelineSideEffect.removeRegacyCards)
    }
    
    // TODO: - 서버 연결 후 수정
    func fetchTimelineTravelInfo() -> SideEffectPublisher {
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                promise(.success(.loadTimeline(TimelineSample.makeTravelInfo())))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // TODO: - 서버 연결 후 수정
    func fetchTimelineCardInfo() -> SideEffectPublisher {
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
                promise(.success(.loadTimelineCardList(TimelineSample.makeCardList())))
            }
        }
        .eraseToAnyPublisher()
    }
}
