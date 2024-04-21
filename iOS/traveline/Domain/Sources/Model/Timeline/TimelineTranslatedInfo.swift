//
//  TimelineTranslatedInfo.swift
//  traveline
//
//  Created by 김태현 on 12/14/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

public struct TimelineTranslatedInfo {
    public let description: String
    
    public static let empty: TimelineTranslatedInfo = .init(description: Literal.empty)
    
    public init(description: String) {
        self.description = description
    }
}
