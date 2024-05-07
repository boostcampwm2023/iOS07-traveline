//
//  TravelListInfo.swift
//  traveline
//
//  Created by 김영인 on 2023/11/17.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

public typealias TravelList = [TravelListInfo]

public struct TravelListInfo: Hashable {
    public let id: String
    public let imageURL: String
    public let imagePath: String
    public let title: String
    public let profile: Profile
    public let like: Int
    public let isLiked: Bool
    public let tags: [Tag]
    
    public init(id: String, imageURL: String, imagePath: String, title: String, profile: Profile, like: Int, isLiked: Bool, tags: [Tag]) {
        self.id = id
        self.imageURL = imageURL
        self.imagePath = imagePath
        self.title = title
        self.profile = profile
        self.like = like
        self.isLiked = isLiked
        self.tags = tags
    }
}
