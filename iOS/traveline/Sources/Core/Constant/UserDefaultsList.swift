//
//  UserDefaultsList.swift
//  traveline
//
//  Created by 김영인 on 2023/11/30.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum UserDefaultsList {
    @UserDefaultsWrapper<UserResponseDTO>(key: "userResponseDTO") static var userResponseDTO
    @UserDefaultsWrapper<[String]>(key: "recentSearchKeyword") static var recentSearchKeyword
}
