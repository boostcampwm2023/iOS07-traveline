//
//  LoginResponseDTO.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/07.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

struct LoginResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}
