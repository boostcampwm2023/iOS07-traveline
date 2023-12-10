//
//  TimelinePlace.swift
//  traveline
//
//  Created by 김영인 on 2023/12/07.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

typealias TimelinePlaceList = [TimelinePlace]

struct TimelinePlace: Hashable {
    let title: String
    let latitude: Double
    let longitude: Double
    
    static let emtpy: Self = .init(
        title: Literal.empty, 
        latitude: 0.0,
        longitude: 0.0
    )
}
