//
//  TravelRepositoryMock.swift
//  traveline
//
//  Created by 김영인 on 2023/12/03.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

final class TravelRepositoryMock: TravelRepository {
    
    func postTravel(data: TravelRequest) async throws -> TravelID {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        return TravelID(value: "id")
    }
    
}
