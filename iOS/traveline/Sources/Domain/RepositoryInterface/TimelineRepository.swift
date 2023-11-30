//
//  TimelineRepository.swift
//  traveline
//
//  Created by 김태현 on 11/30/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

protocol TimelineRepository {
    func fetchTravelInfo(id: String) async throws -> TimelineTravelInfo
}
