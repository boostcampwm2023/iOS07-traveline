//
//  HomeState.swift
//  traveline
//
//  Created by 김영인 on 2023/11/27.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core
import Domain

public struct HomeState: BaseState {
    enum HomeViewType {
        case home
        case recent
        case related
        case result
    }
    
    var filterList: FilterList = .init()
    var travelList: TravelList = .init()
    var searchList: SearchKeywordList = .init()
    var searchQuery: SearchQuery = .init()
    
    var homeViewType: HomeViewType = .home
    var searchText: String = ""
    var homeFilters: FilterDictionary = .make()
    var resultFilters: FilterDictionary = .make()
    var curFilter: Filter? = .emtpy
    var moveToTravelWriting: Bool = false
    var isEmptyResult: Bool = false
    
    var isSearching: Bool {
        homeViewType == .recent || homeViewType == .related
    }
    
    public init() { }
}
