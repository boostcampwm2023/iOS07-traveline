//
//  TravelRequest.swift
//  traveline
//
//  Created by 김영인 on 2023/11/30.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

public struct TravelRequest {
    public let title, region: String
    public let startDate, endDate: Date
    public let tags: [Tag]
    
    public init(title: String, region: String, startDate: Date, endDate: Date, tags: [Tag]) {
        self.title = title
        self.region = region
        self.startDate = startDate
        self.endDate = endDate
        self.tags = tags
    }
}
