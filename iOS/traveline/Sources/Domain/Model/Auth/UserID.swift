//
//  UserID.swift
//  traveline
//
//  Created by 김영인 on 6/1/24.
//  Copyright © 2024 traveline. All rights reserved.
//

import Foundation

import Foundation

struct UserID: Equatable, Hashable {
    let value: String
    
    static let empty: Self = .init(value: "")
}
