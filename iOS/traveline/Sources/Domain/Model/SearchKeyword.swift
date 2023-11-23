//
//  SearchKeyword.swift
//  traveline
//
//  Created by 김영인 on 2023/11/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

typealias SearchKeywordList = [SearchKeyword]

struct SearchKeyword: Hashable {
    let type: SearchViewType
    let title: String
}
