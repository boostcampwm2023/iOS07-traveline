//
//  HomeState.swift
//  traveline
//
//  Created by 김영인 on 2023/11/27.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

struct HomeState: BaseState {
    enum HomeViewType {
        case home
        case recent
        case related
        case result
    }
    
    var homeViewType: HomeViewType = .home
    var searchText: String = ""
    var filters: [FilterType: Filter] = FilterType.allCases.reduce(into: [:]) { filters, type in
        filters[type] = .init(type: type, selected: [])
    }
    var curFilter: Filter? = .emtpy
    var moveToTravelWriting: Bool = false
}
