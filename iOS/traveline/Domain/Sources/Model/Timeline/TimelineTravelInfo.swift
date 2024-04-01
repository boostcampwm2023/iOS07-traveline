//
//  TimelineTravelInfo.swift
//  traveline
//
//  Created by 김태현 on 11/22/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

public struct TimelineTravelInfo: Hashable {
    public let travelTitle: String
    public let startDate: String
    public let endDate: String
    public var isLiked: Bool
    public let isOwner: Bool
    public let tags: [Tag]
    public let days: [String]
    public var day: Int
    
    public static let empty: Self = .init(
        travelTitle: Literal.empty,
        startDate: Literal.empty,
        endDate: Literal.empty,
        isLiked: false,
        isOwner: false,
        tags: [],
        days: [],
        day: 1
    )
}
