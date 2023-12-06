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
            return .just(HomeSideEffect.showPrevious)
            
        case .viewDidLoad, .cancelSearch:
            return .just(HomeSideEffect.showHome)
            
        case .startSearch:
            return fetchRecentKeyword()
            
        case let .searching(searchKeyword):
            return fetchRelatedKeyword(searchKeyword)
            
        case let .searchDone(text):
            return .just(HomeSideEffect.showResult(text))
            
        case let .startFilter(type):
            return .just(HomeSideEffect.showFilter(type))
            
        case let .addFilter(filterList):
            return .just(HomeSideEffect.saveFilter(filterList))
            
        case let .filterChanged(filters):
            return fetchSearchList(from: filters)
            
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
        
        case .showPrevious:
            newState.moveToTravelWriting = false
            newState.curFilter = nil
            newState.homeViewType = state.homeViewType
            
        case let .showRecent(recentSearchKeywordList):
            newState.searchList = recentSearchKeywordList
            newState.homeViewType = .recent
            newState.curFilter = nil
            
        case let .showRelated(relatedSearchKeywordList):
            newState.searchList = relatedSearchKeywordList
            newState.homeViewType = .related
            
        case let .showResult(keyword):
            // TODO: - 서버 연동 후 수정
            newState.travelList = TravelListSample.make()
            newState.homeViewType = .result
            newState.searchText = keyword
            newState.resultFilters = .make()
            saveSearchKeyword(keyword)
            
        case let .showHomeList(travelList):
            // TODO: - 서버 연동 후 수정
            newState.travelList = travelList
            
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
    
    func makeSearchQuery(from filters: FilterDictionary) -> SearchQuery {
        var query = currentState.searchQuery

        query.selectedFilter = filters.values
            .filter { !$0.selected.isEmpty }
            .flatMap { $0.selected }
        
        return query
    }
    
    func fetchSearchList(from filters: FilterDictionary) -> SideEffectPublisher {
        let query = makeSearchQuery(from: filters)
        
        return homeUseCase.fetchSearchList(with: query)
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
    
    func fetchRelatedKeyword(_ keyword: String) -> SideEffectPublisher {
        if keyword.isEmpty { return fetchRecentKeyword() }
        
        return homeUseCase.fetchRelatedKeyword(keyword)
            .map { relatedKeywordList in
                return HomeSideEffect.showRelated(relatedKeywordList)
            }
            .catch { error in
                return Just(HomeSideEffect.loadFailed(error))
            }
            .eraseToAnyPublisher()
    }
}
