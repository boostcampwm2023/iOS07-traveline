//
//  TimelineCardInfo.swift
//  traveline
//
//  Created by 김태현 on 11/23/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

typealias TimelineCardList = [TimelineCardInfo]

struct TimelineCardInfo {
    let detailId: Int
    let thumbnailURL: String
    let title: String
    let subtitle: String
    let content: String
    let time: String
    let latitude: Double
    let longitude: Double
}
