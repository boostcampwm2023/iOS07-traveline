//
//  SeasonFilter.swift
//  traveline
//
//  Created by 김영인 on 2023/11/24.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

enum SeasonFilter: CaseIterable {
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
    
    var query: String {
        switch self {
        case .spring:
            Literal.Query.SeasonDetail.spring
        case .summer:
            Literal.Query.SeasonDetail.summer
        case .fall:
            Literal.Query.SeasonDetail.fall
        case .winter:
            Literal.Query.SeasonDetail.winter
        }
    }
}
