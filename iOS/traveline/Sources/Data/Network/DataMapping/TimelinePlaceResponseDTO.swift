//
//  TimelinePlaceResponseDTO.swift
//  traveline
//
//  Created by 김영인 on 2023/12/07.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

typealias TimelinePlaceListResponseDTO = [TimelinePlaceResponseDTO]

struct TimelinePlaceResponseDTO: Decodable {
    let place: String
    let x: String
    let y: String
    
    enum CodingKeys: String, CodingKey {
        case place = "place_name"
        case x, y
    }
}

extension TimelinePlaceListResponseDTO {
    func toDomain() -> TimelinePlaceList {
        self.map { dto in
                .init(
                    title: dto.place,
                    latitude: dto.x.toDouble(),
                    longitude: dto.y.toDouble()
                )
        }
    }
}
