//
//  KeychainList.swift
//  traveline
//
//  Created by 김영인 on 2023/11/29.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum KeychainList {
    @KeychainWrapper<String>(key: "accessToken") static var accessToken
    @KeychainWrapper<String>(key: "refreshToken") static var refreshToken
}
