//
//  DetailFilter.swift
//  traveline
//
//  Created by 김태현 on 12/6/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

public enum DetailFilter: Hashable {
    case sort(SortFilter)
    case theme(ThemeTag)
    case region(RegionFilter)
    case cost(CostTag)
    case people(PeopleTag)
    case with(WithTag)
    case transportation(TransportationTag)
    case period(PeriodFilter)
    case season(SeasonFilter)
    
    public var title: String {
        switch self {
        case let .sort(sortFilter):
            sortFilter.title
        case let .theme(themeTag):
            themeTag.title
        case let .region(regionFilter):
            regionFilter.title
        case let .cost(costTag):
            costTag.title + Literal.Tag.CostDetail.won
        case let .people(peopleTag):
            peopleTag.title
        case let .with(withTag):
            withTag.title
        case let .transportation(transportationTag):
            transportationTag.title
        case let .period(periodFilter):
            periodFilter.title
        case let .season(seasonFilter):
            seasonFilter.title
        }
    }
}
