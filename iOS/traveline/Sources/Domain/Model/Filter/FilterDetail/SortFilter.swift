//
//  SortFilter.swift
//  traveline
//
//  Created by 김영인 on 2023/11/24.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum SortFilter: CaseIterable {
    case recent
    case like
    
    init?(title: String) {
        switch title {
        case .recent:
            self = .recent
        case .like:
            self = .like
        default:
            return nil
        }
    }
    
    static func ~= (lhs: Self, rhs: String) -> Bool {
        return lhs.title == rhs
    }
    
    var title: String {
        switch self {
        case .recent:
            Literal.Filter.SortDetail.recent
        case .like:
            Literal.Filter.SortDetail.like
        }
    }
    
    var query: String {
        switch self {
        case .recent:
            Literal.Query.SortDetail.recent
        case .like:
            Literal.Query.SortDetail.like
        }
    }
}
