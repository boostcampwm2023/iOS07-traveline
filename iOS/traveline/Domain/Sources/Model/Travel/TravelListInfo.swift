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
}
