//
//  FilterDictionary.swift
//  traveline
//
//  Created by 김영인 on 2023/11/28.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

typealias FilterDictionary = [FilterType: Filter]

extension FilterDictionary {
    static func make() -> Self {
        FilterType.allCases.reduce(into: [:]) { filters, type in
            filters[type] = .init(type: type, selected: [])
        }
    }
}
