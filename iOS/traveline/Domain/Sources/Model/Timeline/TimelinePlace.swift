//
//  TimelinePlace.swift
//  traveline
//
//  Created by 김영인 on 2023/12/07.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

public typealias TimelinePlaceList = [TimelinePlace]

public struct TimelinePlace: Hashable {
    public let title: String
    public let address: String
    public let latitude: Double
    public let longitude: Double
    
    public static let emtpy: Self = .init(
        title: Literal.empty, 
        address: Literal.empty,
        latitude: 0.0,
        longitude: 0.0
    )
    
    public init(
        title: String,
        address: String,
        latitude: Double,
        longitude: Double
    ) {
        self.title = title
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
}
