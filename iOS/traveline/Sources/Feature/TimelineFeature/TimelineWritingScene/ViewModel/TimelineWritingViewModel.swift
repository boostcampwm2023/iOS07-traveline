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
    case metaDataTime(String)
    case searchPlace(String)
    case placeDidChange(TimelinePlace)
    case imageDidChange(Data?)
    case tapCompleteButton
    case placeDidScrollToBottom
    
}

enum TimelineWritingSideEffect: BaseSideEffect {
    enum TimelineWritingError: LocalizedError {
        case createError
        case placeError
        
        var errorDescription: String {
            switch self {
            case .createError: "타임라인 생성에 실패했습니다."
            case .placeError: "장소 검색에 실패했습니다."
            }
        }
    }
    
    case createTimeline
    case updateBasicInfo
    case updateTitleState(String)
    case updateContentState(String)
    case updateTimeState(String)
    case updateImageState(Data?)
    case updatePlaceState(TimelinePlace)
    case updatePlaceKeyword(String)
    case fetchPlaceList(TimelinePlaceList)
    case fetchNextPlaceList(TimelinePlaceList)
    case error(TimelineWritingError)
}

struct TimelineWritingState: BaseState {
    var isCompletable: Bool = false
    var timelineDetailRequest: TimelineDetailRequest = .empty
    var popToTimeline: Bool = false
    var timelinePlaceList: TimelinePlaceList = []
    var keyword: String = ""
    var text: String = ""
    var offset: Int = 1
}

final class TimelineWritingViewModel: BaseViewModel<TimelineWritingAction, TimelineWritingSideEffect, TimelineWritingState> {
    
    private var useCase: TimelineWritingUseCase
    private let id: TravelID
    private let date: String
    private let day: Int
    
    init(
        useCase: TimelineWritingUseCase,
        id: TravelID,
        date: String,
        day: Int
    ) {
        self.useCase = useCase
        self.id = id
        self.date = date
        self.day = day
    }
    
    override func transform(action: TimelineWritingAction) -> SideEffectPublisher {
        switch action {
        case .viewDidLoad:
            return .just(.updateBasicInfo)
            
        case .tapCompleteButton:
            return createTimeline()
            
        case .titleDidChange(let title):
            return .just(.updateTitleState(title))
            
        case .contentDidChange(let content):
            return .just(.updateContentState(content))
            
        case .timeDidChange(let time), .metaDataTime(let time):
            return convertTimeString(time: time)
            
        case .placeDidChange(let place):
            return .just(.updatePlaceState(place))
            
        case .imageDidChange(let imageData):
            return .just(.updateImageState(imageData))
            
        case let .searchPlace(keyword):
            return Publishers.Merge(
                fetchTimelinePlaceList(keyword: keyword),
                Just(TimelineWritingSideEffect.updatePlaceKeyword(keyword))
            )
            .eraseToAnyPublisher()
            
        case .placeDidScrollToBottom:
            return fetchNextPlaceList()
        }
    }
    
    override func reduceState(state: TimelineWritingState, effect: TimelineWritingSideEffect) -> TimelineWritingState {
        var newState = state
        
        switch effect {
        case .updateTitleState(let title):
            newState.timelineDetailRequest.title = title
            newState.isCompletable = completeButtonState(newState)
            
        case .updateContentState(let content):
            if content.count <= 250 {
                newState.text = content
                newState.timelineDetailRequest.content = content
                newState.isCompletable = completeButtonState(newState)
            }
            
        case .updatePlaceState(let place):
            newState.timelineDetailRequest.place = place
            newState.isCompletable = completeButtonState(newState)
            
        case .updateTimeState(let time):
            newState.timelineDetailRequest.time = time
            
        case .updateImageState(let imageData):
            newState.timelineDetailRequest.image = imageData
            
        case .createTimeline:
            newState.popToTimeline = true
            
        case .error:
            break
            
        case .updateBasicInfo:
            newState.timelineDetailRequest.posting = id.value
            newState.timelineDetailRequest.day = day
            if let date = date.convertTimeFormat(from: "yyyy년 MM월 dd일", to: "yyyy-MM-dd") {
                newState.timelineDetailRequest.date = date
            }
            
        case let .updatePlaceKeyword(keyword):
            newState.keyword = keyword
            
        case let .fetchPlaceList(placeList):
            newState.timelinePlaceList = placeList
            newState.offset = 1
            
        case  let .fetchNextPlaceList(placeList):
            newState.timelinePlaceList += placeList
            newState.offset += 1
        }
        
        return newState
    }
    
}

private extension TimelineWritingViewModel {
    
    func convertTimeString(time: String) -> SideEffectPublisher {
        if let time = time.convertTimeFormat(from: "yyyy:MM:dd HH:mm:ss", to: "a hh:mm") {
            return .just(.updateTimeState(time))
        }
        return .just(.updateTimeState(time))
    }
    
    func createTimeline() -> SideEffectPublisher {
        return useCase.requestCreateTimeline(with: currentState.timelineDetailRequest)
            .map { _ in
                return .createTimeline
            } .catch { _ in
                return Just(.error(.createError))
            }
            .eraseToAnyPublisher()
    }
    
    func fetchTimelinePlaceList(keyword: String) -> SideEffectPublisher {
        return useCase.fetchPlaceList(keyword: keyword, offset: 1)
            .map { result in
                return .fetchPlaceList(result)
            } .catch { _ in
                return Just(.error(.placeError))
            }
            .eraseToAnyPublisher()
    }
    
    func fetchNextPlaceList() -> SideEffectPublisher {
        return useCase.fetchPlaceList(
            keyword: currentState.keyword,
            offset: currentState.offset + 1
        )
        .map { result in
            return .fetchNextPlaceList(result)
        } .catch { _ in
            return Just(.error(.placeError))
        }
        .eraseToAnyPublisher()
    }
    
    func completeButtonState(_ state: State) -> Bool {
        return  !state.timelineDetailRequest.title.isEmpty &&
        !state.timelineDetailRequest.content.isEmpty &&
        state.timelineDetailRequest.place != .emtpy
    }
    
}
