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
    case tapCompleteButton(TimelineDetailInfo)
}

enum TimelineWritingSideEffect: BaseSideEffect {
    case createTimeline
    case checkFilledTitle
    case checkFilledContent
}

struct TimelineWritingState: BaseState {
    var isCompletable: Bool = false
}

final class TimelineWritingViewModel: BaseViewModel<TimelineWritingAction, TimelineWritingSideEffect, TimelineWritingState> {
    
    var isFilledTitle: Bool = false
    var isFilledContent: Bool = false
    let postId: String
    let date: String
    let day: Int
    
    init(postId: String, date: String, day: Int) {
        self.postId = postId
        self.date = date
        self.day = day
    }
    
    override func transform(action: TimelineWritingAction) -> SideEffectPublisher {
        switch action {
        case .titleDidChange(let title):
            return checkFilledTitle(title)
            
        case .contentDidChange(let content):
            return checkFilledContent(content)
            
        case .tapCompleteButton(let info):
            return createTimeline(with: info)
        }
    }
    
    override func reduceState(state: TimelineWritingState, effect: TimelineWritingSideEffect) -> TimelineWritingState {
        var newState = state
        
        switch effect {
        case .checkFilledTitle:
            newState.isCompletable = completeButtonState()
            
        case .checkFilledContent:
            newState.isCompletable = completeButtonState()
            
        case .createTimeline:
            break
        }
        
        return newState
    }
    
}

private extension TimelineWritingViewModel {
    
    func createTimeline(with info: TimelineDetailInfo) -> SideEffectPublisher {
        // TODO: - 타임라인 생성 요청
        return .just(SideEffect.createTimeline)
    }
    
    func checkFilledTitle(_ title: String) -> SideEffectPublisher {
        isFilledTitle = title != ""
        print("title\(title)")
        return .just(SideEffect.checkFilledTitle)
    }
    
    func checkFilledContent(_ content: String) -> SideEffectPublisher {
        isFilledContent = content != ""
        print("content\(content)")
        return .just(SideEffect.checkFilledContent)
    }
    
    func completeButtonState() -> Bool {
        return isFilledTitle && isFilledContent
    }
}
