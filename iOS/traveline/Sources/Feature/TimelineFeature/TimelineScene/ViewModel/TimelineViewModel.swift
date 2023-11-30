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
    case loadFailed(Error)
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
    
    private let fetchTravelInfoUseCase: FetchTravelInfoUseCase
    
    init(fetchTravelInfoUseCase: FetchTravelInfoUseCase) {
        self.fetchTravelInfoUseCase = fetchTravelInfoUseCase
    }
    
    // MARK: - Transform
    
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
            
        case .loadFailed(_):
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
            fetchTimelineCardInfo(),
            fetchTravelInfo()
        ).eraseToAnyPublisher()
    }
    
    func fetchTimelineCard() -> SideEffectPublisher {
        return .just(TimelineSideEffect.removeRegacyCards)
    }
    
    func fetchTravelInfo() -> SideEffectPublisher {
        return fetchTravelInfoUseCase.execute(id: "불러올 게시글 ID 값")
            .map { travelInfo in
                return TimelineSideEffect.loadTimeline(travelInfo)
            }
            .catch { error in
                return Just(TimelineSideEffect.loadFailed(error))
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
