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
    case postTravel([Tag])
    case invalidTitle
}

struct TravelState: BaseState {
    var titleText: String = Literal.empty
    var region: String = Literal.empty
    var startDate: Date = .now
    var endDate: Date = .now
    var isValidTitle: Bool = false
    
    var isValidDate: Bool {
        startDate <= endDate
    }
    
    var canPost: Bool {
        isValidTitle && !region.isEmpty && isValidDate
    }
}

final class TravelViewModel: BaseViewModel<TravelAction, TravelSideEffect, TravelState> {
    
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
            // TODO: - Posting API
            Just(TravelSideEffect.postTravel(tags)).eraseToAnyPublisher()
        }
    }
    
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
            
        case let .postTravel(tags):
            // TODO: - Posting 성공 이후 State (타임라인 화면으로 이동?)
            break
            
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
