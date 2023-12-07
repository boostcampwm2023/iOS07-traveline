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
    case viewDidLoad
    case titleDidChange(String)
    case contentDidChange(String)
    case timeDidChange(String)
    case placeDidChange(String)
    case imageDidChange(Data?)
    case tapCompleteButton
    
}

enum TimelineWritingSideEffect: BaseSideEffect {
    case createTimeline(TimelineDetailInfo)
    case updateBasicInfo
    case updateTitleState(String)
    case updateContentState(String)
    case updateTimeState(String)
    case updateImageState(Data?)
    case updatePlaceState(String)
    case error(String)
}

struct TimelineWritingState: BaseState {
    var isCompletable: Bool = false
    var timelineDetailRequest: TimelineDetailRequest = .empty
}

final class TimelineWritingViewModel: BaseViewModel<TimelineWritingAction, TimelineWritingSideEffect, TimelineWritingState> {
    
    private var useCase: TimelineWritingUseCase
    private let postID: String
    private let date: String
    private let day: Int
    
    init(
        useCase: TimelineWritingUseCase,
        postId: String,
        date: String,
        day: Int
    ) {
        self.useCase = useCase
        self.postID = postId
        self.date = date
        self.day = day
    }
    
    override func transform(action: TimelineWritingAction) -> SideEffectPublisher {
        switch action {
        case .viewDidLoad:
            return .just(.updateBasicInfo)
            
        case .tapCompleteButton:
            return createTimeline(with: currentState.timelineDetailRequest)
            
        case .titleDidChange(let title):
            return .just(.updateTitleState(title))
            
        case .contentDidChange(let content):
            return .just(.updateContentState(content))
            
        case .timeDidChange(let time):
            return .just(.updateTimeState(time))
            
        case .placeDidChange(let place):
            return .just(.updatePlaceState(place))
            
        case .imageDidChange(let imageData):
            return .just(.updateImageState(imageData))
        }
    }
    
    override func reduceState(state: TimelineWritingState, effect: TimelineWritingSideEffect) -> TimelineWritingState {
        var newState = state
        
        switch effect {
            
        case .updateTitleState(let title):
            newState.timelineDetailRequest.title = title
            newState.isCompletable = completeButtonState(newState)

            
        case .updateContentState(let content):
            newState.timelineDetailRequest.content = content
            newState.isCompletable = completeButtonState(newState)
            
        case .updatePlaceState(let place):
            newState.timelineDetailRequest.place = place
            newState.isCompletable = completeButtonState(newState)
            
        case .updateTimeState(let time):
            newState.timelineDetailRequest.time = time
            
        case .updateImageState(let imageData):
            newState.timelineDetailRequest.image = imageData
            
        case .createTimeline:
            break
            
        case .error:
            break
            
        case .updateBasicInfo:
            newState.timelineDetailRequest.posting = postID
            newState.timelineDetailRequest.day = day
            newState.timelineDetailRequest.date = date
            
        }
        
        return newState
    }
    
}
    
private extension TimelineWritingViewModel {
    
    func createTimeline(with info: TimelineDetailRequest) -> SideEffectPublisher {
        return useCase.requestCreateTimeline(with: info)
            .map { result in
                return .createTimeline(result)
            } .catch { _ in
                return Just(SideEffect.error("failed create timeline"))
            }
            .eraseToAnyPublisher()
    }
    
    func completeButtonState(_ state: State) -> Bool {
        return  !state.timelineDetailRequest.title.isEmpty &&
                !state.timelineDetailRequest.content.isEmpty &&
                !state.timelineDetailRequest.place.isEmpty
    }
    
}
