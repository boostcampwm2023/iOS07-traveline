//
//  HomeAction.swift
//  traveline
//
//  Created by 김영인 on 2023/11/27.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum HomeAction: BaseAction {
    case viewDidLoad
    case viewWillAppear
    case viewDidAppear
    case startSearch
    case searching(String)
    case searchDone(String)
    case cancelSearch
    case startFilter(FilterType)
    case addFilter([Filter])
    case filterChanged
    case createTravel
    case deleteKeyword(String)
    case didScrollToEnd
    case refresh
}
