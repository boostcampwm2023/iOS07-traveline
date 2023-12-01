//
//  HomeViewModel.swift
//  traveline
//
//  Created by 김영인 on 2023/11/16.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation
import Combine

final class HomeViewModel: BaseViewModel<HomeAction, HomeSideEffect, HomeState> {
    
    private let homeUseCase: HomeUseCase
    
    init(homeUseCase: HomeUseCase) {
        self.homeUseCase = homeUseCase
    }
    
    override func transform(action: Action) -> SideEffectPublisher {
        switch action {
        case .viewDidLoad, .cancelSearch:
            return fetchHomeList()
            
        case .startSearch:
            return .just(HomeSideEffect.showRecent)
            
        case let .searching(text):
            return .just(HomeSideEffect.showRelated(text))
            
        case let .searchDone(text):
            return .just(HomeSideEffect.showResult(text))
            
        case let .startFilter(type):
            return .just(HomeSideEffect.showFilter(type))
            
        case let .addFilter(filterList):
            return .just(HomeSideEffect.saveFilter(filterList))
            
        case .createTravel:
            return .just(HomeSideEffect.showTravelWriting)
        }
    }
    
    override func reduceState(state: State, effect: SideEffect) -> State {
        var newState = state
        
        switch effect {
        case .showRecent:
            // TODO: - 서버 연동 후 수정
            newState.searchList = SearchKeywordSample.makeRecentList()
            newState.homeViewType = .recent
            newState.curFilter = nil
            newState.isSearching = true
            
        case let .showRelated(text):
            // TODO: - 서버 연동 후 수정
            newState.searchList = SearchKeywordSample.makeRelatedList()
            newState.homeViewType = (text.isEmpty) ? .recent : .related
            newState.searchText = text
            newState.isSearching = true
            
        case let .showResult(text):
            // TODO: - 서버 연동 후 수정
            newState.travelList = TravelListSample.make()
            newState.homeViewType = .result
            newState.searchText = text
            newState.isSearching = false
            newState.resultFilters = .make()
            
        case let .showHomeList(travelList):
            // TODO: - 서버 연동 후 수정
            newState.travelList = travelList
            newState.homeViewType = .home
            newState.isSearching = false
            
        case let .showFilter(type):
            newState.curFilter = (state.homeViewType == .home) ? state.homeFilters[type] : state.resultFilters[type]
            
        case let .saveFilter(filterList):
            if state.homeViewType == .home {
                filterList.forEach { newState.homeFilters[$0.type] = $0 }
            } else {
                filterList.forEach { newState.resultFilters[$0.type] = $0 }
            }
            newState.curFilter = nil
            
        case .showTravelWriting:
            newState.moveToTravelWriting = true
            
        case let .loadFailed(error):
            // TODO: - 통신 실패 시 State 처리
            print(error)
        }
        
        return newState
    }
}

// MARK: - Fetch

extension HomeViewModel {
    func fetchHomeList() -> SideEffectPublisher {
        return homeUseCase.fetchHomeList()
            .map { travelList in
                return HomeSideEffect.showHomeList(travelList)
            }
            .catch { error in
                return Just(HomeSideEffect.loadFailed(error))
            }
            .eraseToAnyPublisher()
    }
}
