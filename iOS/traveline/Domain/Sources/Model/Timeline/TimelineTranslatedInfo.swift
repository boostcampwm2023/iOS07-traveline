//
//  TimelineTranslatedInfo.swift
//  traveline
//
//  Created by 김태현 on 12/14/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

struct TimelineTranslatedInfo {
    let description: String
    
    static let empty: TimelineTranslatedInfo = .init(description: Literal.empty)
}
