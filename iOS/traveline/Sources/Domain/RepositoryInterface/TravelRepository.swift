//
//  TravelRepository.swift
//  traveline
//
//  Created by 김영인 on 2023/11/30.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

protocol TravelRepository {
    func postTravel(data: TravelRequest) async throws -> TravelID
}
