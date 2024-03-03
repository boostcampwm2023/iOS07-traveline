//
//  ID.swift
//  traveline
//
//  Created by 김영인 on 2023/12/03.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

struct TravelID: Equatable, Hashable {
    let value: String
    
    static let empty: Self = .init(value: "")
}
