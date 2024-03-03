//
//  UserDefaultsList.swift
//  traveline
//
//  Created by 김영인 on 2023/11/30.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

public enum UserDefaultsList {
    @UserDefaultsWrapper<UserResponseDTO>(key: "userResponseDTO") public static var userResponseDTO
    @UserDefaultsWrapper<[String]>(key: "recentSearchKeyword") public static var recentSearchKeyword
    @UserDefaultsWrapper<Bool>(key: "isFirstEntry") public static var isFirstEntry
}
