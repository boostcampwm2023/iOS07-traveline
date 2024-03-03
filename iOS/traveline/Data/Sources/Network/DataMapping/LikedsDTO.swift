//
//  LikedsDTO.swift
//  traveline
//
//  Created by 김태현 on 11/30/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

struct LikedsDTO: Decodable {
    let user: String
    let posting: String
    let isDeleted: Bool
}
