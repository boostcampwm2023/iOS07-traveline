//
//  TagManager.swift
//  traveline
//
//  Created by 김영인 on 2023/12/04.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

struct TagManager {
    private let tags: [Tag]
    
    init(tags: [Tag]) {
        self.tags = tags
    }
}

extension TagManager {
    func toDTO(type: TagType) -> String? {
        tags.filter { $0.type == type }.first?.title
    }
    
    func toDTO(type: TagType) -> [String] {
        tags.filter { $0.type == type }.map(\.title)
    }
}
