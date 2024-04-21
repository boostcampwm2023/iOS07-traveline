//
//  TravelViewModel.swift
//  traveline
//
//  Created by 김태현 on 11/27/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

import DesignSystem
import Domain

enum TravelAction: BaseAction {
    case configTravelInfo(TimelineTravelInfo)
    case titleEdited(String)
    case regionSelected(String)
    case startDateSelected(Date)
    case endDateSelected(Date)
    case donePressed([Tag])
}

enum TravelSideEffect: BaseSideEffect {
    case showTravelInfo(TravelEditableInfo)
    case saveTitle(String)
    case saveRegion(String)
    case saveStartDate(Date)
    case saveEndDate(Date)
    case postTravel(TravelID?)
    case validateTitle(TitleValidation)
    case error(String)
}

struct TravelState: BaseState {
    var titleText: String = Literal.empty
    var region: String = Literal.empty
    var startDate: Date = .now
    var endDate: Date = .now
    var titleValidation: TitleValidation?
    var travelID: TravelID?
    var errorMsg: String?
    var travelInfo: TravelEditableInfo?
    
    var isValidTitle: Bool {
        titleValidation == .valid
    }
    
    var isValidDate: Bool {
        startDate <= endDate
    }
    
    var canPost: Bool {
        isValidTitle && !region.isEmpty && isValidDate
    }
    
    var isEdit: Bool {
        travelInfo != nil
    }
}

public final class TravelViewModel: BaseViewModel<TravelAction, TravelSideEffect, TravelState> {
    
    private let id: TravelID?
    private let travelUseCase: TravelUseCase
    
    public init(
        id: TravelID?,
        travelInfo: TimelineTravelInfo?,
        travelUseCase: TravelUseCase
    ) {
        self.id = id
        self.travelUseCase = travelUseCase
        super.init()
        
        guard let travelInfo else { return }
        self.sendAction(.configTravelInfo(travelInfo))
    }
    
    // MARK: - Transform
    
    override func transform(action: TravelAction) -> SideEffectPublisher {
        switch action {
        case let .configTravelInfo(travelInfo):
            return toTravelEditableInfo(travelInfo)
            
        case let .titleEdited(title):
            return validate(title: title)
            
        case let .regionSelected(region):
            return .just(TravelSideEffect.saveRegion(region))
            
        case let .startDateSelected(startDate):
            return .just(TravelSideEffect.saveStartDate(startDate))
            
        case let .endDateSelected(endDate):
            return .just(TravelSideEffect.saveEndDate(endDate))
            
        case let .donePressed(tags):
            return postTravel(tags)
        }
    }
    
    // MARK: - ReduceState
    
    override func reduceState(state: TravelState, effect: TravelSideEffect) -> TravelState {
        
        var newState = state
        
        switch effect {
        case let .showTravelInfo(travelInfo):
            newState.travelInfo = travelInfo
            
            guard let region = travelInfo.region,
                  let startDate = travelInfo.startDate,
                  let endDate = travelInfo.endDate else { return newState }
            
            newState.titleValidation = .valid
            newState.titleText = travelInfo.travelTitle
            newState.region = region.title
            newState.startDate = startDate
            newState.endDate = endDate
            
        case let .saveTitle(title):
            newState.titleText = title
            
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
            
        case let .validateTitle(validation):
            newState.titleValidation = validation
        }
        
        return newState
    }
    
}

// MARK: - Validation

private extension TravelViewModel {
    func validate(title: String) -> SideEffectPublisher {
        let titleValidation = travelUseCase.validate(title: title)
        return Publishers.Merge(
            Just(TravelSideEffect.validateTitle(titleValidation)),
            Just(TravelSideEffect.saveTitle(title))
        ).eraseToAnyPublisher()
    }
}

// MARK: - UseCase

private extension TravelViewModel {
    
    func toTravelEditableInfo(_ travelInfo: TimelineTravelInfo) -> SideEffectPublisher {
        let travelEditableInfo = travelUseCase.toEditable(info: travelInfo)
        return .just(TravelSideEffect.showTravelInfo(travelEditableInfo))
    }
    
    func postTravel(_ tags: [Tag]) -> SideEffectPublisher {
        let travelReqeust = TravelRequest(
            title: currentState.titleText,
            region: currentState.region,
            startDate: currentState.startDate,
            endDate: currentState.endDate,
            tags: tags
        )
        
        if currentState.isEdit {
            guard let id = id else { return Empty().eraseToAnyPublisher() }
            
            return travelUseCase.putTravel(id: id, data: travelReqeust)
                .map { id in
                    TravelSideEffect.postTravel(id)
                }
                .catch { _ in
                    Just(TravelSideEffect.error("여행 수정에 실패했습니다."))
                }
                .eraseToAnyPublisher()
        }
        
        return travelUseCase.createTravel(data: travelReqeust)
            .map { id in
                TravelSideEffect.postTravel(id)
            }
            .catch { _ in
                Just(TravelSideEffect.error("여행 생성에 실패했습니다."))
            }
            .eraseToAnyPublisher()
    }
}
