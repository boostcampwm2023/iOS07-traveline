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
        case .viewWillAppear:
            return .just(HomeSideEffect.showHome)
            
        case .viewDidLoad, .cancelSearch:
            return Publishers.Merge(
                Just(HomeSideEffect.showHome),
                fetchHomeList()
            ).eraseToAnyPublisher()
            
        case .startSearch:
            return fetchRecentKeyword()
            
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
            
        case let .deleteKeyword(keyword):
            return deleteSearchKeyword(keyword)
        }
    }
    
    override func reduceState(state: State, effect: SideEffect) -> State {
        var newState = state
        
        switch effect {
        case .showHome:
            newState.moveToTravelWriting = false
            newState.curFilter = nil
            newState.homeViewType = .home
            
        case let .showRecent(recentSearchKeywordList):
            newState.searchList = recentSearchKeywordList
            newState.homeViewType = .recent
            newState.curFilter = nil
            newState.isSearching = true
            
        case let .showRelated(text):
            // TODO: - 서버 연동 후 수정
            newState.searchList = SearchKeywordSample.makeRelatedList()
            newState.homeViewType = (text.isEmpty) ? .recent : .related
            newState.searchText = text
            newState.isSearching = true
            
        case let .showResult(keyword):
            // TODO: - 서버 연동 후 수정
            newState.travelList = TravelListSample.make()
            newState.homeViewType = .result
            newState.searchText = keyword
            newState.isSearching = false
            newState.resultFilters = .make()
            saveSearchKeyword(keyword)
            
        case let .showHomeList(travelList):
            // TODO: - 서버 연동 후 수정
            newState.travelList = travelList
            newState.homeViewType = .home
            newState.isSearching = false
            
        case let .showFilter(type):
            newState.curFilter = (state.homeViewType == .home) ? state.homeFilters[type] : state.resultFilters[type]
            newState.moveToTravelWriting = false
            
        case let .saveFilter(filterList):
            if state.homeViewType == .home {
                filterList.forEach { newState.homeFilters[$0.type] = $0 }
            } else {
                filterList.forEach { newState.resultFilters[$0.type] = $0 }
            }
            newState.curFilter = nil
            
        case .showTravelWriting:
            newState.curFilter = nil
            newState.moveToTravelWriting = true
            
        case let .loadFailed(error):
            // TODO: - 통신 실패 시 State 처리
            print(error)
        }
        
        return newState
    }
}

// MARK: - Functions

private extension HomeViewModel {
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
    
    func fetchRecentKeyword() -> SideEffectPublisher {
        return homeUseCase.fetchRecentKeyword()
            .map { recentKeywordList in
                return HomeSideEffect.showRecent(recentKeywordList)
            }.eraseToAnyPublisher()
    }
    
    func saveSearchKeyword(_ keyword: String) {
        homeUseCase.saveRecentKeyword(keyword)
    }
    
    func deleteSearchKeyword(_ keyword: String) -> SideEffectPublisher {
        return homeUseCase.deleteRecentKeyword(keyword)
            .map { recentKeywordList in
                return HomeSideEffect.showRecent(recentKeywordList)
            }.eraseToAnyPublisher()
    }
}
