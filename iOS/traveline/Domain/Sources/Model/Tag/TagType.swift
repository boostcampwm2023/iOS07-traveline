//
//  TagType.swift
//  Domain
//
//  Created by 김영인 on 2023/11/17.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

public enum TagType: CaseIterable {
    case region
    case period
    case theme
    case season
    case cost
    case people
    case with
    case transportation
    
    public var title: String {
        switch self {
        case .region:
            Literal.Tag.region
        case .period:
            Literal.Tag.period
        case .season:
            Literal.Tag.season
        case .theme:
            Literal.Tag.theme
        case .cost:
            Literal.Tag.cost
        case .people:
            Literal.Tag.people
        case .with:
            Literal.Tag.with
        case .transportation:
            Literal.Tag.transportation
        }
    }
    
    public var subtitle: String? {
        switch self {
        case .cost:
            Literal.Tag.costSubtitle
        default:
            nil
        }
    }
    
    public var detailTags: [String] {
        switch self {
        case .theme:
            ThemeTag.allCases.map { $0.title }
        case .cost:
            CostTag.allCases.map { $0.title }
        case .people:
            PeopleTag.allCases.map { $0.title }
        case .with:
            WithTag.allCases.map { $0.title }
        case .transportation:
            TransportationTag.allCases.map { $0.title }
        case .region:
            RegionFilter.allCases.map { $0.title }
        case .period:
            PeriodFilter.allCases.map { $0.title }
        case .season:
            SeasonFilter.allCases.map { $0.title }
        }
    }
    
    public var isMultiple: Bool {
        switch self {
        case .theme, .with: true
        default: false
        }
    }
    
    public var isBasic: Bool {
        switch self {
        case .region, .period, .season: true
        default: false
        }
    }
}
