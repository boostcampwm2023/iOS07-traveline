//
//  Filter.swift
//  traveline
//
//  Created by 김영인 on 2023/11/26.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

public typealias FilterList = [Filter]

extension FilterList {
    public static func sortFilters(_ filters: FilterDictionary) -> FilterList {
        filters.map { $0.value }.sorted { $0.type.id < $1.type.id }
    }
}

public struct Filter: Hashable {
    public let type: FilterType
    public let selected: [DetailFilter]
    public var isSelected: Bool {
        !selected.isEmpty
    }
    
    public static var emtpy: Self {
        .init(type: .empty, selected: [])
    }
    
    public init(type: FilterType, selected: [DetailFilter]) {
        self.type = type
        self.selected = selected
    }
}
