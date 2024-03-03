//
//  SortFilter.swift
//  traveline
//
//  Created by 김영인 on 2023/11/24.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

enum SortFilter: CaseIterable {
    case recent
    case like
    
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
