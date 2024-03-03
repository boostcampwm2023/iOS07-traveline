//
//  ErrorResponseDTO.swift
//  traveline
//
//  Created by 김태현 on 12/7/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

struct ErrorResponseDTO: Decodable {
    let message: String
    let error: String
    let statusCode: Int
}
