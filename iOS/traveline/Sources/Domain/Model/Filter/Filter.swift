//
//  Filter.swift
//  traveline
//
//  Created by 김영인 on 2023/11/26.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

typealias FilterList = [Filter]

extension FilterList {
    static func sortFilters(_ filters: FilterDictionary) -> FilterList {
        filters.map { $0.value }.sorted { $0.type.id < $1.type.id }
    }
}

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
