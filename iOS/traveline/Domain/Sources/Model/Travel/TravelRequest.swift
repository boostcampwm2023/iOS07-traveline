//
//  TravelRequest.swift
//  traveline
//
//  Created by 김영인 on 2023/11/30.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

struct TravelRequest {
    let title, region: String
    let startDate, endDate: Date
    let tags: [Tag]
}
