//
//  CostTag.swift
//  traveline
//
//  Created by 김태현 on 11/21/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

enum CostTag: DetailTagType {
    case under10
    case under50
    case under100
    case over100
    
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
