//
//  TimelineCardInfo.swift
//  traveline
//
//  Created by 김태현 on 11/23/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

typealias TimelineCardList = [TimelineCardInfo]

struct TimelineCardInfo: Hashable {
    let detailId: String
    let thumbnailURL: String?
    let imagePath: String?
    let title: String
    let place: String?
    let content: String
    let time: String
    let latitude: Double?
    let longitude: Double?
    
    static let empty: Self = .init(
        detailId: Literal.empty,
        thumbnailURL: Literal.empty,
        imagePath: Literal.empty,
        title: Literal.empty,
        place: Literal.empty,
        content: Literal.empty,
        time: Literal.empty,
        latitude: 0,
        longitude: 0
    )
}
