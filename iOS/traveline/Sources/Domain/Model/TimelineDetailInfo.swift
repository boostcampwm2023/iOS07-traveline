//
//  TimelineDetail.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/22.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

struct TimelineDetailInfo: Hashable {
    let id: String
    let title: String
    let day: Int
    let description: String
    let imageURL: String?
    let coordX: String?
    let coordY: String?
    let date: String
    let location: String?
    let time: String
    
    init(
        id: String,
        title: String,
        day: Int,
        description: String,
        imageURL: String? = nil,
        coordX: String? = nil,
        coordY: String? = nil,
        date: String,
        location: String? = nil,
        time: String
    ) {
        self.id = id
        self.title = title
        self.day = day
        self.description = description
        self.imageURL = imageURL
        self.coordX = coordX
        self.coordY = coordY
        self.date = date
        self.location = location
        self.time = time
    }
    
    static let empty: TimelineDetailInfo = .init(
        id: Literal.empty,
        title: Literal.empty,
        day: 0,
        description: Literal.empty,
        date: Literal.empty,
        time: Literal.empty
    )
    
    static func == (lhs: TimelineDetailInfo, rhs: TimelineDetailInfo) -> Bool {
        lhs.id == rhs.id
    }
}
