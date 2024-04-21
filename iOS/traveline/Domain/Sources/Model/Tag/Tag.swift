//
//  Tag.swift
//  Domain
//
//  Created by 김영인 on 2023/11/17.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

public struct Tag: Hashable {
    public let title: String
    public let type: TagType
    
    public static func makeDefaultTag(_ type: TagType) -> Self {
        .init(title: type.title, type: type)
    }
    
    public func toRegionFilter() -> RegionFilter? {
        return RegionFilter.allCases.first { $0.title == title }
    }
    
    public init(title: String, type: TagType) {
        self.title = title
        self.type = type
    }
}
