//
//  Tag.swift
//  traveline
//
//  Created by 김영인 on 2023/11/17.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

struct Tag: Hashable {
    let title: String
    let type: TagType
    
    static func makeDefaultTag(_ type: TagType) -> Self {
        .init(title: type.title, type: type)
    }
    
    func toRegionFilter() -> RegionFilter? {
        return RegionFilter.allCases.first { $0.title == title }
    }
}
