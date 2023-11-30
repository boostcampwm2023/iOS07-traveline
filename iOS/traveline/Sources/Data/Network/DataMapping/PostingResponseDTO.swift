//
//  PostingResponseDTO.swift
//  traveline
//
//  Created by 김태현 on 11/30/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

struct PostingResponseDTO: Decodable {
    let id: String
    let title: String
    let createdAt: String
    let thumbnail: String?
    let startDate: String
    let endDate: String
    let days: [String]
    let period: String
    let headcount: String
    let budget: String?
    let location: String
    let season: String
    let vehicle: String?
    let theme: [String]
    let withWho: String?
    let likeds: [LikedsDTO]
    let writer: WriterDTO
    let liked: Int
    let report: Int
    let isLiked: Bool
    let isOwner: Bool
    
    func toDomain() -> TimelineTravelInfo {
        return .init(
            travelTitle: title,
            startDate: startDate,
            endDate: endDate,
            isLiked: isLiked,
            // TODO: - 태그 합치는 작업
            tags: []
        )
    }
}

struct LikedsDTO: Decodable {
    let user: String
    let posting: String
    let isDeleted: Bool
}

struct WriterDTO: Decodable {
    let id: String
    let name: String
    let avatar: String?
    let resourceId: String
    let socialType: Int
}
