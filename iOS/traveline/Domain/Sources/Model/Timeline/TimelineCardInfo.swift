//
//  TimelineCardInfo.swift
//  traveline
//
//  Created by 김태현 on 11/23/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

public typealias TimelineCardList = [TimelineCardInfo]

public struct TimelineCardInfo: Hashable {
    public let detailId: String
    public let thumbnailURL: String?
    public let imagePath: String?
    public let title: String
    public let place: String?
    public let content: String
    public let time: String
    public let latitude: Double?
    public let longitude: Double?
    
    public static let empty: Self = .init(
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
    
    public init(
        detailId: String,
        thumbnailURL: String?,
        imagePath: String?,
        title: String,
        place: String?,
        content: String,
        time: String,
        latitude: Double?,
        longitude: Double?
    ) {
        self.detailId = detailId
        self.thumbnailURL = thumbnailURL
        self.imagePath = imagePath
        self.title = title
        self.place = place
        self.content = content
        self.time = time
        self.latitude = latitude
        self.longitude = longitude
    }
}
