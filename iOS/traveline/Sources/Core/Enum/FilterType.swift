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
    
    var detailFilters: [String] {
        switch self {
        case .empty:
            []
        case .sort:
            SortFilter.allCases.map { $0.title }
        case .total:
            TagType.allCases.map { $0.title }
        case let .tagtype(tag):
            switch tag {
            case .cost:
                tag.detailTags.map { $0 + Literal.Tag.CostDetail.won }
            default:
                tag.detailTags
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
        return [.total, .sort] + TagType.allCases.map { .tagtype($0) }
    }
}
