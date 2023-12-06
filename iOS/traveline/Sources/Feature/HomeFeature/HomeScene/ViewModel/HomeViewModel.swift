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
            
        case .viewDidLoad:
            return .just(HomeSideEffect.showHome)
            
        case .cancelSearch:
            return Publishers.Merge(
                Just(HomeSideEffect.showHome),
                fetchHomeList()
            ).eraseToAnyPublisher()
            
        case .startSearch:
            return fetchRecentKeyword()
            
        case let .searching(searchKeyword):
            return fetchRelatedKeyword(searchKeyword)
            
        case let .searchDone(keyword):
            return fetchSearchResult(from: keyword)
            
        case let .startFilter(type):
            return .just(HomeSideEffect.showFilter(type))
            
        case let .addFilter(filterList):
            return .just(HomeSideEffect.saveFilter(filterList))
            
        case let .filterChanged(filters):
            return fetchNewSearchList(from: filters)
            
        case .createTravel:
            return .just(HomeSideEffect.showTravelWriting)
            
        case let .deleteKeyword(keyword):
            return deleteSearchKeyword(keyword)
            
        case .didScrollToEnd:
            return fetchNextPage()
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
            
        case let .showSearchResult(searchResult):
            newState.travelList = searchResult.travelList
            newState.homeViewType = .result
            newState.resultFilters = .make()
            newState.searchQuery = .init(
                keyword: searchResult.keyword,
                offset: 2
            )
            
        case let .showNewList(travelList):
            newState.travelList = travelList
            newState.searchQuery.offset = 2
            
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
            
        case let .showNextPage(travelList):
            newState.travelList += travelList
            newState.searchQuery.offset += 1
            
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
    
    func fetchHomeList() -> SideEffectPublisher {
        var query = makeSearchQuery(from: state.homeFilters)
        query.offset = 1
        
        return homeUseCase.fetchSearchList(with: query)
            .map { travelList in
                return HomeSideEffect.showNewList(travelList)
            }
            .catch { error in
                return Just(HomeSideEffect.loadFailed(error))
            }
            .eraseToAnyPublisher()
    }
    
    func fetchNewSearchList(from filters: FilterDictionary) -> SideEffectPublisher {
        var query = makeSearchQuery(from: filters)
        query.offset = 1
        
        return homeUseCase.fetchSearchList(with: query)
            .map { travelList in
                return HomeSideEffect.showNewList(travelList)
            }
            .catch { error in
                return Just(HomeSideEffect.loadFailed(error))
            }
            .eraseToAnyPublisher()
    }
    
    func fetchNextPage() -> SideEffectPublisher {
        let filters = state.homeViewType == .home ? state.homeFilters : state.resultFilters
        let query = makeSearchQuery(from: filters)
        
        return homeUseCase.fetchSearchList(with: query)
            .map { travelList in
                return HomeSideEffect.showNextPage(travelList)
            }
            .catch { error in
                return Just(HomeSideEffect.loadFailed(error))
            }
            .eraseToAnyPublisher()
    }
    
    func fetchSearchResult(from keyword: String) -> SideEffectPublisher {
        saveSearchKeyword(keyword)
        let query = SearchQuery(keyword: keyword)
        
        return homeUseCase.fetchSearchList(with: query)
            .map { travelList in
                return HomeSideEffect.showSearchResult(
                    SearchResult(
                        keyword: keyword,
                        travelList: travelList
                    )
                )
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
