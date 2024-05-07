//
//  TimelineTranslatedResponseDTO.swift
//  traveline
//
//  Created by 김태현 on 12/14/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Domain

struct TimelineTranslatedResponseDTO: Decodable {
    let description: String
}

extension TimelineTranslatedResponseDTO {
    func toDomain() -> TimelineTranslatedInfo {
        return .init(description: description)
    }
}
