//
//  HomeSideEffect.swift
//  traveline
//
//  Created by 김영인 on 2023/11/27.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core
import Domain

public enum HomeSideEffect: BaseSideEffect {
    case showHome
    case showPrevious
    case showRecent(SearchKeywordList)
    case showRelated(SearchKeywordList)
    case showSearchResult(SearchResult)
    case showNewHomeList(TravelList)
    case showNewList(TravelList)
    case showFilter(FilterType)
    case saveFilter([Filter])
    case showTravelWriting
    case loadFailed(Error)
    case showNextPage(TravelList)
}
