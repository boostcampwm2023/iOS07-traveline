//
//  ID.swift
//  traveline
//
//  Created by 김영인 on 2023/12/03.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

public struct TravelID: Equatable, Hashable {
    public let value: String
    
    public static let empty: Self = .init(value: "")
    
    public init(value: String) {
        self.value = value
    }
}
