//
//  TimelineDetailViewModel.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/30.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

import DesignSystem
import Domain

enum TimelineDetailAction: BaseAction {
    case viewWillAppear
    case editTimeline
    case deleteTimeline
    case translateTimeline
    case movedToEdit
}

enum TimelineDetailSideEffect: BaseSideEffect {
    enum TimelineDetailError: LocalizedError {
        case loadFailed
        case deleteFailed
        
        var errorDescription: String? {
            switch self {
            case .loadFailed: "서버 통신에 실패했습니다."
            case .deleteFailed: "타임라인 삭제에 실패했습니다."
            }
        }
    }
    
    case loadTimelineDetail(TimelineDetailInfo)
    case timelineDetailError(TimelineDetailError)
    case popToTimeline(Bool)
    case showTimelineDetailEditing
    case loadTimelineTranslatedInfo(TimelineTranslatedInfo)
    case resetIsEditStatus
}

struct TimelineDetailState: BaseState {
    var timelineDetailInfo: TimelineDetailInfo = .empty
    var timelineTranslatedInfo: TimelineTranslatedInfo = .empty
    var isOwner: Bool = false
    var isDeleteCompleted: Bool = false
    var isEdit: Bool = false
    var isTranslated: Bool = false
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
        case .viewWillAppear:
            return loadTimelineDetailInfo()
            
        case .editTimeline:
            return .just(.showTimelineDetailEditing)
            
        case .deleteTimeline:
            return deleteTimeline()
            
        case .translateTimeline:
            return translateTimeline()
        
        case .movedToEdit:
            return .just(.resetIsEditStatus)
        }
    }

    override func reduceState(state: State, effect: SideEffect) -> State {
        var newState = state
        
        switch effect {
        case .loadTimelineDetail(let info):
            newState.timelineDetailInfo = info
            newState.isOwner = info.isOwner
            
        case let .popToTimeline(isSuccess):
            newState.isDeleteCompleted = isSuccess
            
        case .showTimelineDetailEditing:
            newState.isEdit = true
            
        case .loadTimelineTranslatedInfo(let translatedInfo):
            newState.timelineTranslatedInfo = translatedInfo
            newState.isTranslated.toggle()
            
        case let .timelineDetailError(error):
            print(error)
            
        case .resetIsEditStatus:
            newState.isEdit = false
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
            .catch { _ in
                return Just(TimelineDetailSideEffect.timelineDetailError(.loadFailed))
            }
            .eraseToAnyPublisher()
    }
    
    func deleteTimeline() -> SideEffectPublisher {
        return timelineDetailUseCase.deleteTimeline(id: id)
            .map { isSuccess in
                return .popToTimeline(isSuccess)
            }
            .catch { _ in
                return Just(TimelineDetailSideEffect.timelineDetailError(.deleteFailed))
            }
            .eraseToAnyPublisher()
    }
    
    func translateTimeline() -> SideEffectPublisher {
        return timelineDetailUseCase.fetchTranslateTimelineDetail(with: id)
            .map { translatedInfo in
                return .loadTimelineTranslatedInfo(translatedInfo)
            }
            .catch { _ in
                return Just(TimelineDetailSideEffect.timelineDetailError(.deleteFailed))
            }
            .eraseToAnyPublisher()
    }
}
