//
//  TimelineTravelInfo.swift
//  traveline
//
//  Created by 김태현 on 11/22/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

struct TimelineTravelInfo: Hashable {
    let travelTitle: String
    let startDate: String
    let endDate: String
    let isLiked: Bool
    let tags: [Tag]
}
