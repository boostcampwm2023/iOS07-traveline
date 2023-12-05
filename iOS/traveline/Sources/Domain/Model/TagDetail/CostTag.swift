//
//  CostTag.swift
//  traveline
//
//  Created by 김태현 on 11/21/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum CostTag: DetailTagType {
    case under10
    case under50
    case under100
    case over100
    
    init?(title: String) {
        switch title {
        case .under10:
            self = .under10
        case .under50:
            self = .under50
        case .under100:
            self = .under100
        case .over100:
            self = .over100
        default:
            return nil
        }
    }
    
    static func ~= (lhs: Self, rhs: String) -> Bool {
        return lhs.title == rhs
    }
    
    var title: String {
        switch self {
        case .under10:
            Literal.Tag.CostDetail.under10
        case .under50:
            Literal.Tag.CostDetail.under50
        case .under100:
            Literal.Tag.CostDetail.under100
        case .over100:
            Literal.Tag.CostDetail.over100
        }
    }
    
    var query: String {
        switch self {
        case .under10:
            Literal.Query.CostDetail.under10
        case .under50:
            Literal.Query.CostDetail.under50
        case .under100:
            Literal.Query.CostDetail.under100
        case .over100:
            Literal.Query.CostDetail.over100
        }
    }
}
