//
//  TimelineViewModel.swift
//  traveline
//
//  Created by 김태현 on 11/28/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

enum TimelineManageType {
    case none
    case delete
    case block
    case report
    
    private enum Constants {
        static let didFinishDeleteWithSuccess: String = "여행 삭제를 완료했어요 !"
        static let didFinishDeleteWithFailure: String = "여행 삭제에 실패했어요."
        static let didFinishBlock: String = "해당 사용자를 차단했어요."
        static let didFinishReport: String = "해당 게시글을 신고했어요."
    }
    
    var description: String {
        switch self {
        case .delete: Constants.didFinishDeleteWithSuccess
        case .block: Constants.didFinishBlock
        case .report: Constants.didFinishReport
        default: ""
        }
    }
}

enum TimelineAction: BaseAction {
    case viewWillAppear
    case enterToTimeline
    case fetchTimelineCard(Int)
    case changeDay(Int)
    case likeButtonPressed
    case createPostingButtonPressed
    case editTravel
    case deleteTravel
    case reportTravel
    case blockTravel
}

enum TimelineSideEffect: BaseSideEffect {
    enum TimelineError: LocalizedError {
        case loadFailed
        case deleteFailed
        case reportFailed
        case likeFailed
        case blockFailed
        
        var errorDescription: String? {
            switch self {
            case .loadFailed: "서버 통신에 실패했습니다."
            case .deleteFailed: "여행 삭제에 실패했습니다."
            case .reportFailed: "여행 신고에 실패했습니다."
            case .likeFailed: "여행 좋아요에 실패했습니다."
            case .blockFailed: "사용자 차단에 실패했습니다."
            }
        }
    }
    
    case loadTimeline(TimelineTravelInfo)
    case loadTimelineCardList(TimelineCardList)
    case removeRegacyCards(Int)
    case updateCurDate(String)
    case toggleLike
    case showTimelineWriting
    case showTimelineEditing
    case popToTimeline
    case popToHome(TimelineManageType)
    case timelineError(TimelineError)
    case resetState
    case none
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
    var isEdit: Bool = false
    var timelineManageType: TimelineManageType = .none
    var errorMsg: String?
    var isEmptyList: Bool = false
}

final class TimelineViewModel: BaseViewModel<TimelineAction, TimelineSideEffect, TimelineState> {
    
    private(set) var id: TravelID
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
        case .viewWillAppear:
            return .just(.resetState)
            
        case .enterToTimeline:
            return fetchTimeline()
            
        case let .fetchTimelineCard(day):
            return fetchTimelineCardInfo(day)
            
        case let .changeDay(day):
            return fetchTimelineCard(day)
            
        case .likeButtonPressed:
            return Publishers.Merge(
                Just(.toggleLike),
                likeTravel()
            )
            .eraseToAnyPublisher()
            
        case .createPostingButtonPressed:
            return .just(.showTimelineWriting)
            
        case .editTravel:
            return .just(.showTimelineEditing)
            
        case .deleteTravel:
            return deleteTravel()
            
        case .reportTravel:
            return reportTravel()
            
        case .blockTravel:
            return blockTravel()
        }
    }
    
    override func reduceState(state: TimelineState, effect: TimelineSideEffect) -> TimelineState {
        var newState = state
        
        switch effect {
        case .none:
            return newState
            
        case .resetState:
            newState.isEdit = false
            newState.timelineManageType = .none
            newState.timelineWritingInfo = nil
            
        case let .loadTimeline(travelInfo):
            newState.travelInfo = travelInfo
            newState.isOwner = travelInfo.isOwner
            newState.date = timelineUseCase.calculateDate(from: travelInfo.startDate, with: state.day)
            newState.day = currentState.day
            newState.travelInfo.day = currentState.day
            
        case let .loadTimelineCardList(timelineCardList):
            newState.timelineCardList = timelineCardList
            newState.isEmptyList = timelineCardList.isEmpty
            
        case let .removeRegacyCards(day):
            newState.day = day
            newState.travelInfo.day = day
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
            
        case .popToTimeline:
            newState.timelineWritingInfo = nil
            
        case .popToHome(let type):
            newState.timelineManageType = type
            
        case let .updateCurDate(date):
            newState.date = date
            
        case .showTimelineEditing:
            newState.isEdit = true
        }
        
        return newState
    }
}

// MARK: - Fetch

private extension TimelineViewModel {
    func fetchTimeline() -> SideEffectPublisher {
        Publishers.MergeMany(
            .just(.popToTimeline),
            fetchTimelineCardInfo(currentState.day),
            fetchTravelInfo()
        ).eraseToAnyPublisher()
    }
    
    func fetchTimelineCard(_ day: Int) -> SideEffectPublisher {
        return .just(.removeRegacyCards(day))
    }
    
    func fetchTravelInfo() -> SideEffectPublisher {
        return timelineUseCase.fetchTimelineInfo(id: id)
            .map { travelInfo in
                return .loadTimeline(travelInfo)
            }
            .catch {_ in
                return Just(.timelineError(.loadFailed))
            }
            .eraseToAnyPublisher()
    }
    
    func fetchTimelineCardInfo(_ day: Int) -> SideEffectPublisher {
        return timelineUseCase.fetchTimelineList(id: id, day: day)
            .map { list in
                return .loadTimelineCardList(list)
            }
            .catch { _ in
                return Just(.timelineError(.loadFailed))
            }
            .eraseToAnyPublisher()
    }
    
    func deleteTravel() -> SideEffectPublisher {
        return timelineUseCase.deleteTravel(id: id)
            .map { _ in
                return .popToHome(.delete)
            }
            .catch { _ in
                return Just(.timelineError(.deleteFailed))
            }
            .eraseToAnyPublisher()
    }
    
    // TODO: 서버 연동 필요
    func blockTravel() -> SideEffectPublisher {
        return timelineUseCase.reportTravel(id: id)
            .map { _ in
                return .popToHome(.block)
            }
            .catch { _ in
                return Just(.timelineError(.blockFailed))
            }
            .eraseToAnyPublisher()
    }
    
    func reportTravel() -> SideEffectPublisher {
        return timelineUseCase.reportTravel(id: id)
            .map { _ in
                return .popToHome(.report)
            }
            .catch { _ in
                return Just(.timelineError(.reportFailed))
            }
            .eraseToAnyPublisher()
    }
    
    func likeTravel() -> SideEffectPublisher {
        return timelineUseCase.likeTravel(id: id)
            .map { _ in
                return .none
            }
            .catch { _ in
                return Just(.timelineError(.likeFailed))
            }
            .eraseToAnyPublisher()
    }
    
}
