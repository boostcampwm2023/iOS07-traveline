//
//  PeopleTag.swift
//  traveline
//
//  Created by 김태현 on 11/21/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

public enum PeopleTag: DetailTagType {
    case one
    case two
    case three
    case four
    case overFive
    
    var title: String {
        switch self {
        case .one:
            Literal.Tag.PeopleDetail.one
        case .two:
            Literal.Tag.PeopleDetail.two
        case .three:
            Literal.Tag.PeopleDetail.three
        case .four:
            Literal.Tag.PeopleDetail.four
        case .overFive:
            Literal.Tag.PeopleDetail.overFive
        }
    }
    
    var query: String {
        switch self {
        case .one:
            Literal.Query.PeopleDetail.one
        case .two:
            Literal.Query.PeopleDetail.two
        case .three:
            Literal.Query.PeopleDetail.three
        case .four:
            Literal.Query.PeopleDetail.four
        case .overFive:
            Literal.Query.PeopleDetail.overFive
        }
    }
}
