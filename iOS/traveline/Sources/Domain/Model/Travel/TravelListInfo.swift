//
//  TravelListInfo.swift
//  traveline
//
//  Created by 김영인 on 2023/11/17.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

typealias TravelList = [TravelListInfo]

struct TravelListInfo: Hashable {
    let id: String
    let imageURL: String
    let imagePath: String
    let title: String
    let profile: Profile
    let like: Int
    let isLiked: Bool
    let tags: [Tag]
}
