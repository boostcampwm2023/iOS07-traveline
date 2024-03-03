//
//  FilterType.swift
//  traveline
//
//  Created by 김영인 on 2023/11/21.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum FilterType: Equatable, CaseIterable, Hashable {
    case empty
    case total
    case sort
    case tagtype(TagType)
    
    var title: String {
        switch self {
        case .empty, .total:
            Literal.empty
        case .sort:
            Literal.Filter.sort
        case let .tagtype(tag):
            tag.title
        }
    }
    
    var detailFilters: [DetailFilter] {
        switch self {
        case .empty, .total:
            []
        case .sort:
            SortFilter.allCases.map { DetailFilter.sort($0) }
        case let .tagtype(tag):
            switch tag {
            case .theme:
                ThemeTag.allCases.map { DetailFilter.theme($0) }
            case .region:
                RegionFilter.allCases.map { DetailFilter.region($0) }
            case .cost:
                CostTag.allCases.map { DetailFilter.cost($0) }
            case .people:
                PeopleTag.allCases.map { DetailFilter.people($0) }
            case .with:
                WithTag.allCases.map { DetailFilter.with($0) }
            case .transportation:
                TransportationTag.allCases.map { DetailFilter.transportation($0) }
            case .period:
                PeriodFilter.allCases.map { DetailFilter.period($0) }
            case .season:
                SeasonFilter.allCases.map { DetailFilter.season($0) }
            }
        }
    }
    
    var isMultiple: Bool {
        switch self {
        case .empty, .sort:
            false
        case .total:
            true
        case let .tagtype(tag):
            switch tag {
            case .region, .season, .with, .theme:
                true
            default:
                false
            }
        }
    }
    
    var id: Int {
        switch self {
        case .total: 1
        case .sort: 2
        case let .tagtype(tag):
            switch tag {
            case .region: 3
            case .period: 4
            case .theme: 5
            case .season: 6
            case .cost: 7
            case .people: 8
            case .with: 9
            case .transportation: 10
            }
        default:
            0
        }
    }
    
    static var allCases: [FilterType] {
        return [.sort] + TagType.allCases.map { .tagtype($0) }
    }
}
