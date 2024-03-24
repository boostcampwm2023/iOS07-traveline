//
//  Profile.swift
//  traveline
//
//  Created by 김영인 on 2023/11/17.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

public struct Profile: Hashable, Codable {
    public let imageURL: String
    public let imagePath: String
    public let name: String
    
    public static let empty: Profile = .init(
        imageURL: Literal.empty,
        imagePath: Literal.empty,
        name: Literal.empty
    )
    
    public init(
        imageURL: String,
        imagePath: String,
        name: String
    ) {
        self.imageURL = imageURL
        self.imagePath = imagePath
        self.name = name
    }
}
