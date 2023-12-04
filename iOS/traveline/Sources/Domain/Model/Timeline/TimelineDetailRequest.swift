//
//  TimelineDetailRequest.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/05.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation
struct TimelineDetailRequest {
    var title: String
    let day: Int
    var time: String
    let date: String
    var place: String
    var image: Data?
    var content: String
    let posting: String
}
