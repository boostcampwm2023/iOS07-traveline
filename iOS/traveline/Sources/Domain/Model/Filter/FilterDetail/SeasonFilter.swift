//
//  SeasonFilter.swift
//  traveline
//
//  Created by 김영인 on 2023/11/24.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum SeasonFilter: DetailFilterType {
    case spring
    case summer
    case fall
    case winter
    
    var title: String {
        switch self {
        case .spring:
            Literal.Filter.SeasonDetail.spring
        case .summer:
            Literal.Filter.SeasonDetail.summer
        case .fall:
            Literal.Filter.SeasonDetail.fall
        case .winter:
            Literal.Filter.SeasonDetail.winter
        }
    }
}
