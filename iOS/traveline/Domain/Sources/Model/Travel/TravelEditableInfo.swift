//
//  TravelEditableInfo.swift
//  traveline
//
//  Created by 김영인 on 2023/12/10.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

struct TravelEditableInfo: Hashable {
    let travelTitle: String
    let region: RegionFilter?
    let startDate: Date?
    let endDate: Date?
    let tags: [Tag]
    
    static let empty: Self = .init(
        travelTitle: Literal.empty,
        region: nil,
        startDate: .now,
        endDate: .now,
        tags: []
    )
}
