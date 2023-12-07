//
//  AppleLoginRequestDTO.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/07.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

struct AppleLoginRequestDTO: Encodable {
    
    let idToken: String
    let email: String?
    
    init(idToken: String, email: String? = nil) {
        self.idToken = idToken
        self.email = email
    }
}

extension AppleLoginRequest {
    func toDTO() -> AppleLoginRequestDTO {
        return .init(
            idToken: idToken,
            email: email
        )
    }
}
