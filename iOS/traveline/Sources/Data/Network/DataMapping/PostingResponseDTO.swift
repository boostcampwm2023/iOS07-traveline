//
//  PostingResponseDTO.swift
//  traveline
//
//  Created by 김태현 on 11/30/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

typealias PostingListResponseDTO = [PostingResponseDTO]

struct PostingResponseDTO: Decodable {
    let id: String
    let title: String
    let createdAt: String
    let thumbnail: String?
    let startDate: String
    let endDate: String
    let days: Int
    let period: String
    let headcount: String?
    let budget: String?
    let location: String
    let season: String
    let vehicle: String?
    let theme: [String]?
    let withWho: [String]?
    let writer: WriterDTO
}

// MARK: - Mapping

extension PostingResponseDTO {
    func toDomain() -> TravelListInfo {
        return .init(
            id: id,
            imageURL: thumbnail ?? Literal.empty,
            title: title,
            profile: .init(
                imageURL: writer.avatar ?? Literal.empty,
                name: writer.name
            ),
            // TODO: - 서버 반환 값 변경 후 수정
            like: 100,
            isLiked: true,
            tags: [
                .init(title: location, type: .region),
                .init(title: period, type: .people),
                .init(title: season, type: .season)
            ]
        )
    }
}
