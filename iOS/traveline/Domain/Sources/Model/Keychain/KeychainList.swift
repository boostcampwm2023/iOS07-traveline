//
//  KeychainList.swift
//  Domain
//
//  Created by 김영인 on 2023/11/29.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

public enum KeychainList {
    @KeychainWrapper<String>(key: "accessToken") public static var accessToken
    @KeychainWrapper<String>(key: "refreshToken") public static var refreshToken
    @KeychainWrapper<String>(key: "identityToken") public static var identityToken
    @KeychainWrapper<String>(key: "authorizationCode") public static var authorizationCode
    
    public static func allClear() {
        accessToken = nil
        refreshToken = nil
        identityToken = nil
        authorizationCode = nil
    }
}
