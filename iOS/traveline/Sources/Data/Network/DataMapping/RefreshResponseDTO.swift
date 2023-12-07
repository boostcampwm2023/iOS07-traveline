//
//  RefreshResponseDTO.swift
//  traveline
//
//  Created by 김태현 on 12/7/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

struct RefreshResponseDTO: Decodable {
    let accessToken: String
}

extension RefreshResponseDTO {
    func toDomain() -> String {
        return accessToken
    }
}
