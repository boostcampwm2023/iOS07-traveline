//
//  FilterType.swift
//  traveline
//
//  Created by 김영인 on 2023/11/21.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum FilterType: Equatable, CaseIterable, Hashable {
    case empty
    case total
    case sort
    case tagtype(TagType)
    
    var title: String {
        switch self {
        case .empty, .total:
            Literal.empty
        case .sort:
            Literal.Filter.sort
        case let .tagtype(tag):
            tag.title
        }
    }
    
    static var allCases: [FilterType] {
        return [.total, .sort] + TagType.allCases.map { .tagtype($0) }
    }
}
