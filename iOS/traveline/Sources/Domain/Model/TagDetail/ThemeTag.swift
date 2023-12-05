//
//  ThemeTag.swift
//  traveline
//
//  Created by 김태현 on 11/21/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum ThemeTag: DetailTagType {
    case healing
    case activity
    case camping
    case restaurant
    case art
    case emotion
    case nature
    case shopping
    case filialPiety
    
    init?(title: String) {
        switch title {
        case .healing:
            self = .healing
        case .activity:
            self = .activity
        case .camping:
            self = .camping
        case .restaurant:
            self = .restaurant
        case .art:
            self = .art
        case .emotion:
            self = .emotion
        case .nature:
            self = .nature
        case .shopping:
            self = .shopping
        case .filialPiety:
            self = .filialPiety
        default:
            return nil
        }
    }
    
    static func ~= (lhs: Self, rhs: String) -> Bool {
        return lhs.title == rhs
    }
    
    var title: String {
        switch self {
        case .healing:
            Literal.Tag.ThemeDetail.healing
        case .activity:
            Literal.Tag.ThemeDetail.activity
        case .camping:
            Literal.Tag.ThemeDetail.camping
        case .restaurant:
            Literal.Tag.ThemeDetail.restaurant
        case .art:
            Literal.Tag.ThemeDetail.art
        case .emotion:
            Literal.Tag.ThemeDetail.emotion
        case .nature:
            Literal.Tag.ThemeDetail.nature
        case .shopping:
            Literal.Tag.ThemeDetail.shopping
        case .filialPiety:
            Literal.Tag.ThemeDetail.filialPiety
        }
    }
    
    var query: String {
        switch self {
        case .healing:
            Literal.Query.ThemeDetail.healing
        case .activity:
            Literal.Query.ThemeDetail.activity
        case .camping:
            Literal.Query.ThemeDetail.camping
        case .restaurant:
            Literal.Query.ThemeDetail.restaurant
        case .art:
            Literal.Query.ThemeDetail.art
        case .emotion:
            Literal.Query.ThemeDetail.emotion
        case .nature:
            Literal.Query.ThemeDetail.nature
        case .shopping:
            Literal.Query.ThemeDetail.shopping
        case .filialPiety:
            Literal.Query.ThemeDetail.filialPiety
        }
    }
}
