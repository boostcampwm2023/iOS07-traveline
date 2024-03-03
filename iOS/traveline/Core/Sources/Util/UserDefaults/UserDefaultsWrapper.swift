//
//  UserDefaultsWrapper.swift
//  traveline
//
//  Created by 김영인 on 2023/11/30.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

@propertyWrapper public struct UserDefaultsWrapper<T: Codable> {
    
    public var wrappedValue: T? {
        get {
            if let data = UserDefaults.standard.object(forKey: key) as? Data {
                if let value = try? JSONDecoder().decode(T.self, from: data) {
                    return value
                }
            }
            
            return defaultValue
        }
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: key)
            } else {
                if let encoded = try? JSONEncoder().encode(newValue) {
                    UserDefaults.standard.setValue(encoded, forKey: key)
                }
            }
        }
    }
    
    private let key: String
    private let defaultValue: T?
    
    init(key: String, defaultValue: T? = nil) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
