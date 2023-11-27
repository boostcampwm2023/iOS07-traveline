//
//  Filter.swift
//  traveline
//
//  Created by 김영인 on 2023/11/26.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

typealias FilterList = [Filter]

struct Filter: Hashable {
    let type: FilterType
    let selected: [String]
    var isSelected: Bool {
        !selected.isEmpty
    }
    
    static var emtpy: Self {
        .init(type: .empty, selected: [])
    }
}
