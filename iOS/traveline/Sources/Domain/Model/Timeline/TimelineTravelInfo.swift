//
//  TimelineTravelInfo.swift
//  traveline
//
//  Created by 김태현 on 11/22/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

struct TimelineTravelInfo: Hashable {
    let travelTitle: String
    let startDate: String
    let endDate: String
    var isLiked: Bool
    let isOwner: Bool
    let tags: [Tag]
    let days: [String]
    
    static let empty: Self = .init(
        travelTitle: Literal.empty,
        startDate: Literal.empty,
        endDate: Literal.empty,
        isLiked: false,
        isOwner: false,
        tags: [],
        days: []
    )
}
