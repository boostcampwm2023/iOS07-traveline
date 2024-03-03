//
//  TagManager.swift
//  traveline
//
//  Created by 김영인 on 2023/12/04.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

public struct TagManager {
    private let tags: [Tag]
    
    init(tags: [Tag]) {
        self.tags = tags
    }
}

extension TagManager {
    public func toDTO(type: TagType) -> String? {
        tags.filter { $0.type == type }.first?.title
    }
    
    public func toDTO(type: TagType) -> [String]? {
        tags.filter { $0.type == type }.map(\.title)
    }
}
