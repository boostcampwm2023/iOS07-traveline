//
//  HomeViewModelType.swift
//  traveline
//
//  Created by 김영인 on 2023/11/18.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

struct HomeViewModelType: ViewModelType {
    enum Action {
        case searchStart(String)
        case searchDone(String)
    }
    
    enum SideEffect {
        case fetchSearchAPI
        case fetchSearchResultAPI
    }
    
    struct State: BaseState {
        var value: Int = 0
    }
}
