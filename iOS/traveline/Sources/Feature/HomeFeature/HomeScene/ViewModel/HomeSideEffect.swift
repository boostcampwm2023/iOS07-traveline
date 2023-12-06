//
//  HomeSideEffect.swift
//  traveline
//
//  Created by 김영인 on 2023/11/27.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum HomeSideEffect: BaseSideEffect {
    case showHome
    case showPrevious
    case showRecent(SearchKeywordList)
    case showRelated(SearchKeywordList)
    case showResult(String)
    case showNewList(TravelList)
    case showFilter(FilterType)
    case saveFilter([Filter])
    case showTravelWriting
    case loadFailed(Error)
    case showNextPage(TravelList)
}
