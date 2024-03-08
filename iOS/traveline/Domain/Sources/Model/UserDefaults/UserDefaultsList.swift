//
//  UserDefaultsList.swift
//  Domain
//
//  Created by 김영인 on 2023/11/30.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

public enum UserDefaultsList {
    @UserDefaultsWrapper<Profile>(key: "profile") public static var profile
    @UserDefaultsWrapper<[String]>(key: "recentSearchKeyword") public static var recentSearchKeyword
    @UserDefaultsWrapper<Bool>(key: "isFirstEntry") public static var isFirstEntry
}
