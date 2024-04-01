//
//  TimelineDetailRequest.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/05.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

public struct TimelineDetailRequest {
    public var title: String
    public var day: Int
    public var time: String
    public var date: String
    public var place: TimelinePlace?
    public var image: Data?
    public var content: String
    public var posting: String
    
    public static let empty: TimelineDetailRequest = .init(
        title: Literal.empty,
        day: 0,
        time: Literal.empty,
        date: Literal.empty,
        content: Literal.empty,
        posting: Literal.empty
    )
}
