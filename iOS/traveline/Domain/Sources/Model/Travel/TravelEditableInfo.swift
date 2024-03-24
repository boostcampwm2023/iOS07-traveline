//
//  TravelEditableInfo.swift
//  traveline
//
//  Created by 김영인 on 2023/12/10.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

public struct TravelEditableInfo: Hashable {
    public let travelTitle: String
    public let region: RegionFilter?
    public let startDate: Date?
    public let endDate: Date?
    public let tags: [Tag]
    
    public static let empty: Self = .init(
        travelTitle: Literal.empty,
        region: nil,
        startDate: .now,
        endDate: .now,
        tags: []
    )
}
