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
    case imageDidChange
    case placeDidScrollToBottom
    case tapCompleteButton(Data?)
    case configTimelineDetailInfo(TimelineDetailInfo)
}

enum TimelineWritingSideEffect: BaseSideEffect {
    enum TimelineWritingError: LocalizedError {
        case createError
        case placeError
        case putError
        
        var errorDescription: String {
            switch self {
            case .createError: "타임라인 생성에 실패했습니다."
            case .placeError: "장소 검색에 실패했습니다."
            case .putError: "타임라인 수정에 실패했습니다."
            }
        }
    }
    
    case createTimeline
    case updateBasicInfo
    case updateTitleState(String)
    case updateContentState(String)
    case updateTimeState(String)
    case updateImageState
    case updatePlaceState(TimelinePlace)
    case updatePlaceKeyword(String)
    case fetchPlaceList(TimelinePlaceList)
    case fetchNextPlaceList(TimelinePlaceList)
    case showTimelineInfo(TimelineDetailRequest)
    case setOriginImage(String?)
    case popToTimelineDetail(Bool)
    case error(TimelineWritingError)
}

struct TimelineWritingState: BaseState {
    var isOriginImage: Bool = false
    var isCompletable: Bool = false
    var timelineDetailRequest: TimelineDetailRequest = .empty
    var popToTimeline: Bool = false
    var timelinePlaceList: TimelinePlaceList = []
    var keyword: String = ""
    var text: String = ""
    var offset: Int = 1
    var imageURLString: String?
    var isEdit: Bool = false
    var isEditCompleted: Bool = false
}

final class TimelineWritingViewModel: BaseViewModel<TimelineWritingAction, TimelineWritingSideEffect, TimelineWritingState> {
    
    private var useCase: TimelineWritingUseCase
    private let id: TravelID
    private let date: String
    private let day: Int
    private let timelineID: String?
    
    init(
        useCase: TimelineWritingUseCase,
        id: TravelID,
        date: String,
        day: Int,
        timelineDetailInfo: TimelineDetailInfo?
    ) {
        self.useCase = useCase
        self.id = id
        self.date = date
        self.day = day
        self.timelineID = timelineDetailInfo?.id
        super.init()
        
        guard let timelineDetailInfo else { return }
        sendAction(.configTimelineDetailInfo(timelineDetailInfo))
    }
    
    override func transform(action: TimelineWritingAction) -> SideEffectPublisher {
        switch action {
        case .viewDidLoad:
            return .just(.updateBasicInfo)
            
        case .tapCompleteButton(let imageData):
            return createTimeline(with: imageData)
            
        case .titleDidChange(let title):
            return .just(.updateTitleState(title))
            
        case .contentDidChange(let content):
            return .just(.updateContentState(content))
            
        case .timeDidChange(let time), .metaDataTime(let time):
            return convertTimeString(time: time)
            
        case .placeDidChange(let place):
            return .just(.updatePlaceState(place))
            
        case .imageDidChange:
            return .just(.updateImageState)
            
        case let .searchPlace(keyword):
            return Publishers.Merge(
                fetchTimelinePlaceList(keyword: keyword),
                Just(TimelineWritingSideEffect.updatePlaceKeyword(keyword))
            )
            .eraseToAnyPublisher()
            
        case .placeDidScrollToBottom:
            return fetchNextPlaceList()
            
        case let .configTimelineDetailInfo(detailInfo):
            return Publishers.Merge(
                Just(TimelineWritingSideEffect.setOriginImage(detailInfo.imageURL)),
                toTimelineDetailRequest(from: detailInfo)
            )
            .eraseToAnyPublisher()
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
            
        case .updateImageState:
            newState.isOriginImage = false
            
        case .createTimeline:
            newState.isEditCompleted = true
            
        case .error:
            newState.isEditCompleted = false
            
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
            
        case let .showTimelineInfo(detailRequest):
            newState.timelineDetailRequest = detailRequest
            newState.isEdit = true
            newState.isCompletable = completeButtonState(newState)
            
        case let .setOriginImage(imageURL):
            newState.imageURLString = imageURL
            newState.isOriginImage = true
            
        case let .popToTimelineDetail(isSuccess):
            newState.isEditCompleted = isSuccess
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
    
    func createTimeline(with imageData: Data?) -> SideEffectPublisher {
        var request = currentState.timelineDetailRequest
        request.image = imageData
        
        if currentState.isEdit {
            return putTimeline(with: request)
        }
        
        return useCase.requestCreateTimeline(with: request)
            .map { _ in
                return .createTimeline
            } .catch { _ in
                return Just(.error(.createError))
            }
            .eraseToAnyPublisher()
    }
    
    func putTimeline(with timelineDetailRequest: TimelineDetailRequest) -> SideEffectPublisher {
        guard let timelineID else { return Empty().eraseToAnyPublisher() }
        return useCase.putTimeline(id: timelineID, info: timelineDetailRequest)
            .map { isSuccess in
                return .popToTimelineDetail(isSuccess)
            } .catch { _ in
                return Just(.error(.putError))
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
    
    func toTimelineDetailRequest(from info: TimelineDetailInfo) -> SideEffectPublisher {
        let timelineDetailRequest = useCase.toTimelineDetailRequest(from: info)
        return .just(.showTimelineInfo(timelineDetailRequest))
    }
    
}
