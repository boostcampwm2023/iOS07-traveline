//
//  PeriodFilter.swift
//  traveline
//
//  Created by 김영인 on 2023/11/24.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum PeriodFilter: DetailFilterType {
    case one
    case two
    case three
    case overThree
    case week
    case month
    
    init?(title: String) {
        switch title {
        case PeriodFilter.one.title:
            self = .one
        case PeriodFilter.two.title:
            self = .two
        case PeriodFilter.three.title:
            self = .three
        case PeriodFilter.overThree.title:
            self = .overThree
        case PeriodFilter.week.title:
            self = .week
        case PeriodFilter.month.title:
            self = .month
        default:
            return nil
        }
    }
    
    static func ~= (lhs: Self, rhs: String) -> Bool {
        return lhs.title == rhs
    }
    
    var title: String {
        switch self {
        case .one:
            Literal.Filter.PeriodDetail.one
        case .two:
            Literal.Filter.PeriodDetail.two
        case .three:
            Literal.Filter.PeriodDetail.three
        case .overThree:
            Literal.Filter.PeriodDetail.overThree
        case .week:
            Literal.Filter.PeriodDetail.week
        case .month:
            Literal.Filter.PeriodDetail.month
        }
    }
    
    var query: String {
        switch self {
        case .one:
            Literal.Query.PeriodDetail.one
        case .two:
            Literal.Query.PeriodDetail.two
        case .three:
            Literal.Query.PeriodDetail.three
        case .overThree:
            Literal.Query.PeriodDetail.overThree
        case .week:
            Literal.Query.PeriodDetail.week
        case .month:
            Literal.Query.PeriodDetail.month
        }
    }
}
