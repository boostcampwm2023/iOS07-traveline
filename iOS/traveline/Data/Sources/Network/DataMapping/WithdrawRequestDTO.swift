//
//  withdrawRequestDTO.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/07.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Domain

struct WithdrawRequestDTO: Encodable {
    let idToken: String
    let authorizationCode: String
}

extension WithdrawRequest {
    func toDTO() -> WithdrawRequestDTO {
        return .init(
            idToken: idToken,
            authorizationCode: authorizationCode
        )
    }
    
}
