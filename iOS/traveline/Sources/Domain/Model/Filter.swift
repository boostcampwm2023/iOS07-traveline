//
//  Filter.swift
//  traveline
//
//  Created by 김영인 on 2023/11/22.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

typealias FilterList = [Filter]

struct Filter: Hashable {
    let type: FilterType
    let isSelected: Bool
}

extension Filter {
    static let empty: Self = .init(type: .empty, isSelected: false)
}
