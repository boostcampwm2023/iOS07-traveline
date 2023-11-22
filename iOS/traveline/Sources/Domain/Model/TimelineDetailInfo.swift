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
    let day: String
    let title: String
    let date: String
    let time: String
    let location: String
    let content: String
    let imageURL: String
    
    static func == (lhs: TimelineDetailInfo, rhs: TimelineDetailInfo) -> Bool {
        lhs.id == rhs.id
    }
}
