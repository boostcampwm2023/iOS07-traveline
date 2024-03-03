//
//  WithTag.swift
//  traveline
//
//  Created by 김태현 on 11/21/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

enum WithTag: DetailTagType {
    case family
    case friend
    case couple
    case pet
    
    var title: String {
        switch self {
        case .family:
            Literal.Tag.WithDetail.family
        case .friend:
            Literal.Tag.WithDetail.friend
        case .couple:
            Literal.Tag.WithDetail.couple
        case .pet:
            Literal.Tag.WithDetail.pet
        }
    }
    
    var query: String {
        switch self {
        case .family:
            Literal.Query.WithDetail.family
        case .friend:
            Literal.Query.WithDetail.friend
        case .couple:
            Literal.Query.WithDetail.couple
        case .pet:
            Literal.Query.WithDetail.pet
        }
    }
}
