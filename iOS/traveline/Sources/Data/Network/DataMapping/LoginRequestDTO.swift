//
//  LoginRequestDTO.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/07.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

struct LoginRequestDTO: Encodable {
    
    let idToken: String
    let email: String?
    
    init(idToken: String, email: String? = nil) {
        self.idToken = idToken
        self.email = email
    }
    
}
