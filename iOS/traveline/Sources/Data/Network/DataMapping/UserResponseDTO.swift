//
//  File.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/04.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

struct UserResponseDTO: Decodable {
    let name: String
    let avatar: String?
}

extension UserResponseDTO {
    func toDomain() -> Profile {
        return .init(
            imageURL: avatar ?? "",
            name: name
        )
    }
}
