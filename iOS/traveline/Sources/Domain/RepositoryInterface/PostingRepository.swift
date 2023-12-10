//
//  PostingRepository.swift
//  traveline
//
//  Created by 김태현 on 11/30/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

protocol PostingRepository {
    func fetchPostingList(with query: SearchQuery) async throws -> TravelList
    func fetchMyPostingList() async throws -> TravelList
    func fetchRecentKeyword() -> [String]?
    func saveRecentKeyword(_ keyword: String)
    func saveRecentKeywordList(_ keywordList: [String])
    func deleteRecentKeyword(_ keyword: String)
    func fetchPostingTitleList(_ keyword: String) async throws -> SearchKeywordList
    func fetchTimelineInfo(id: TravelID) async throws -> TimelineTravelInfo
    func postPosting(data: TravelRequest) async throws -> TravelID
    func putPosting(id: TravelID, data: TravelRequest) async throws -> TravelID
    func deletePosting(id: TravelID) async throws -> Bool
    func postReport(id: TravelID) async throws -> Bool
    func postLike(id: TravelID) async throws -> Bool
}
