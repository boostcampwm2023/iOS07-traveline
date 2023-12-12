//
//  WriterDTO.swift
//  traveline
//
//  Created by 김태현 on 11/30/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

struct WriterDTO: Decodable {
    let id: String
    let name: String
    let avatar: String?
}
