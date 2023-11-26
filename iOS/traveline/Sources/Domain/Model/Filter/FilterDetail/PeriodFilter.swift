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
}
