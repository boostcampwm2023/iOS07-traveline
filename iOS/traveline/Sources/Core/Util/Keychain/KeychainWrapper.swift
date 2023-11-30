//
//  KeychainWrapper.swift
//  traveline
//
//  Created by 김영인 on 2023/11/29.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

@propertyWrapper struct KeychainWrapper<T> {
    
    var wrappedValue: T? {
        get {
            return KeychainManager.read(forKey: key) as? T
        }
        set {
            if newValue == nil {
                KeychainManager.delete(forKey: key)
            } else {
                KeychainManager.set(newValue, forKey: key)
            }
        }
    }
    
    private let key: String
    
    init(key: String) {
        self.key = key
    }
}
