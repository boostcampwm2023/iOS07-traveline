//
//  KeychainWrapper.swift
//  traveline
//
//  Created by 김영인 on 2023/11/29.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

@propertyWrapper public struct KeychainWrapper<T> {
    
    public var wrappedValue: T? {
        get {
           KeychainManager.read(forKey: key) as? T
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
    
    public init(key: String) {
        self.key = key
    }
}
