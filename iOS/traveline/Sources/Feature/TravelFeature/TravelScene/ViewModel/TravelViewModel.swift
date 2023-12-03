//
//  TravelViewModel.swift
//  traveline
//
//  Created by 김태현 on 11/27/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

enum TravelAction: BaseAction {
    case titleEdited(String)
    case regionSelected(String)
    case startDateSelected(Date)
    case endDateSelected(Date)
    case donePressed([Tag])
}

enum TravelSideEffect: BaseSideEffect {
    case saveTitle(String)
    case saveRegion(String)
    case saveStartDate(Date)
    case saveEndDate(Date)
    case postTravel(TravelID?)
    case invalidTitle
    case error(String)
}

struct TravelState: BaseState {
    var titleText: String = Literal.empty
    var region: String = Literal.empty
    var startDate: Date = .now
    var endDate: Date = .now
    var isValidTitle: Bool = false
    var travelID: TravelID?
    var errorMsg: String?
    
    var isValidDate: Bool {
        startDate <= endDate
    }
    
    var canPost: Bool {
        isValidTitle && !region.isEmpty && isValidDate
    }
}

final class TravelViewModel: BaseViewModel<TravelAction, TravelSideEffect, TravelState> {
    
    private let travelUseCase: TravelUseCase
    
    init(travelUseCase: TravelUseCase) {
        self.travelUseCase = travelUseCase
    }
    
    // MARK: - Transform
    
    override func transform(action: TravelAction) -> SideEffectPublisher {
        switch action {
        case let .titleEdited(title):
            validate(title: title)
            
        case let .regionSelected(region):
            Just(TravelSideEffect.saveRegion(region)).eraseToAnyPublisher()
            
        case let .startDateSelected(startDate):
            Just(TravelSideEffect.saveStartDate(startDate)).eraseToAnyPublisher()
            
        case let .endDateSelected(endDate):
            Just(TravelSideEffect.saveEndDate(endDate)).eraseToAnyPublisher()
            
        case let .donePressed(tags):
            postTravel(tags)
        }
    }
    
    // MARK: - ReduceState
    
    override func reduceState(state: TravelState, effect: TravelSideEffect) -> TravelState {
        var newState = state
        
        switch effect {
        case let .saveTitle(title):
            newState.titleText = title
            newState.isValidTitle = true
            
        case let .saveRegion(region):
            newState.region = region
            
        case let .saveStartDate(startDate):
            newState.startDate = startDate
            if !newState.isValidDate { newState.endDate = startDate }
            
        case let .saveEndDate(endDate):
            newState.endDate = endDate
            
        case let .postTravel(id):
            newState.travelID = id
            
        case let .error(msg):
            newState.errorMsg = msg
            
        case .invalidTitle:
            newState.isValidTitle = false
        }
        
        return newState
    }
    
}

// MARK: - Validation

private extension TravelViewModel {
    // TODO: - 정규식을 통한 제목 유효성 검사
    func validate(title: String) -> SideEffectPublisher {
        if 1...14 ~= title.count {
            Just(TravelSideEffect.saveTitle(title)).eraseToAnyPublisher()
        } else {
            Just(TravelSideEffect.invalidTitle).eraseToAnyPublisher()
        }
    }
}

// MARK: - UseCase

private extension TravelViewModel {
    func postTravel(_ tags: [Tag]) -> SideEffectPublisher {
        let travelReqeust = TravelRequest(
            title: state.titleText,
            region: state.region,
            startDate: state.startDate,
            endDate: state.endDate,
            tags: tags
        )
        
        return travelUseCase.createTravel(data: travelReqeust)
            .map { id in
                TravelSideEffect.postTravel(id)
            }
            .catch { _ in
                Just(TravelSideEffect.error("postTravel에 실패했습니다."))
            }
            .eraseToAnyPublisher()
    }
}
