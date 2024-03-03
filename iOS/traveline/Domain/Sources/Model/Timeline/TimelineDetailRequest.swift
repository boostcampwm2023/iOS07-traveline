//
//  TimelineDetailRequest.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/05.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

struct TimelineDetailRequest {
    var title: String
    var day: Int
    var time: String
    var date: String
    var place: TimelinePlace?
    var image: Data?
    var content: String
    var posting: String
    
    static let empty: TimelineDetailRequest = .init(
        title: Literal.empty,
        day: 0,
        time: Literal.empty,
        date: Literal.empty,
        content: Literal.empty,
        posting: Literal.empty
    )
}
