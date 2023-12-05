//
//  TimelineWritingViewModel.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/29.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

enum TimelineWritingAction: BaseAction {
    case titleDidChange(String)
    case contentDidChange(String)
    case timeDidChange(String)
    case placeDidChange(String)
    case imageDidChange(Data?)
    case tapCompleteButton(TimelineDetailInfo)
    
}

enum TimelineWritingSideEffect: BaseSideEffect {
    case createTimeline
    case updateTitleState
    case updateContentState
    case updateTimeState
    case updateImageState
    case updatePlaceState
}

struct TimelineWritingState: BaseState {
    var isCompletable: Bool = false
}

final class TimelineWritingViewModel: BaseViewModel<TimelineWritingAction, TimelineWritingSideEffect, TimelineWritingState> {
    
    private var isFilledTitle: Bool = false
    private var isFilledContent: Bool = false
    var timelineDetailRequest: TimelineDetailRequest
    private var useCase: TimelineWritingUseCase
    
    init(
        useCase: TimelineWritingUseCase,
        postId: String,
        date: String,
        day: Int
    ) {
        self.useCase = useCase
        self.timelineDetailRequest = .init(
            title: Literal.empty,
            day: day,
            time: Literal.empty,
            date: date,
            place: Literal.empty,
            content: Literal.empty,
            posting: postId
        )
    }
    
    override func transform(action: TimelineWritingAction) -> SideEffectPublisher {
        switch action {
        case .tapCompleteButton(let info):
            return createTimeline(with: info)
            
        case .titleDidChange(let title):
            return updateTitleState(title)
            
        case .contentDidChange(let content):
            return updateContentState(content)
            
        case .timeDidChange(let time):
            return updateTimeState(time)
            
        case .placeDidChange(let place):
            return updatePlaceState(place)
            
        case .imageDidChange(let imageData):
            return updateImageState(imageData)
        }
    }
    
    override func reduceState(state: TimelineWritingState, effect: TimelineWritingSideEffect) -> TimelineWritingState {
        var newState = state
        
        switch effect {
        case .updateTitleState,
             .updateContentState,
             .updatePlaceState:
            newState.isCompletable = completeButtonState()
            
        case .updateTimeState:
            break
            
        case .updateImageState:
            break
            
        case .createTimeline:
            break
        }
        
        return newState
    }
    
}

private extension TimelineWritingViewModel {
    
    func createTimeline(with info: TimelineDetailInfo) -> SideEffectPublisher {
        let _ = useCase.requestCreateTimeline(with: timelineDetailRequest)
        return .just(SideEffect.createTimeline)
    }
    
    func completeButtonState() -> Bool {
        return  timelineDetailRequest.title != Literal.empty &&
                timelineDetailRequest.content != Literal.empty &&
                timelineDetailRequest.place != Literal.empty
    }
    
    func updateTitleState(_ title: String) -> SideEffectPublisher {
        timelineDetailRequest.title = title
        return .just(.updateTitleState)
    }
    
    func updateContentState(_ content: String) -> SideEffectPublisher {
        timelineDetailRequest.content = content
        return .just(.updateContentState)
    }
    
    func updateImageState(_ data: Data?) -> SideEffectPublisher {
        timelineDetailRequest.image = data
        return .just(.updateImageState)
    }
    
    func updateTimeState(_ time: String) -> SideEffectPublisher {
        timelineDetailRequest.time = time
        return .just(.updateTimeState)
    }
    
    func updatePlaceState(_ place: String) -> SideEffectPublisher {
        timelineDetailRequest.place = place
        return .just(.updatePlaceState)
    }
}
