//
//  TimelineResponseDTO.swift
//  traveline
//
//  Created by 김영인 on 2023/12/05.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

/*
 게시글의 Day N에 해당하는 모든 타임라인 반환
 */

typealias TimelineListResponseDTO = [TimelineResponseDTO]

struct TimelineResponseDTO: Decodable {
    let id: String
    let title: String
    let description: String
    let image: String?
    let coordX: Double?
    let coordY: Double?
    let place: String
    let time: String
}

extension TimelineListResponseDTO {
    func toDomain() -> TimelineCardList {
        self.map { dto in
                .init(
                    detailId: dto.id,
                    thumbnailURL: dto.image,
                    title: dto.title,
                    place: dto.place,
                    content: dto.description,
                    time: dto.time,
                    latitude: dto.coordX ?? 0,
                    longitude: dto.coordY ?? 0
                )
        }
    }
}
