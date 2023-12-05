//
//  TimelineDetailViewModel.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/30.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

enum TimelineDetailAction: BaseAction {
    case viewDidLoad
}

enum TimelineDetailSideEffect: BaseSideEffect {
    case loadTimelineDetail(TimelineDetailInfo)
    case loadFailed
    
}

struct TimelineDetailState: BaseState {
    var timelineDetailInfo: TimelineDetailInfo = .empty
}

final class TimelineDetailViewModel: BaseViewModel<TimelineDetailAction, TimelineDetailSideEffect, TimelineDetailState> {
    
    private let timelineDetailUseCase: TimelineDetailUseCase
    private let id: String
    
    init(timelineDetailUseCase: TimelineDetailUseCase, timelineId: String) {
        self.timelineDetailUseCase = timelineDetailUseCase
        self.id = timelineId
    }
    
    override func transform(action: Action) -> SideEffectPublisher {
        switch action {
        case .viewDidLoad:
            return loadTimelineDetailInfo()
        }
    }

    override func reduceState(state: State, effect: SideEffect) -> State {
        var newState = state
        
        switch effect {
        case .loadTimelineDetail(let info):
            newState.timelineDetailInfo = info
        case .loadFailed:
            break
        }
        
        return newState
    }
}

private extension TimelineDetailViewModel {
    func loadTimelineDetailInfo() -> SideEffectPublisher {
        return timelineDetailUseCase.fetchTimelineDetail(with: id)
            .map { info in
                return TimelineDetailSideEffect.loadTimelineDetail(info)
            }
            .catch { error in
                return Just(TimelineDetailSideEffect.loadFailed)
            }
            .eraseToAnyPublisher()
    }
}
