//
//  KeychainManager.swift
//  traveline
//
//  Created by 김영인 on 2023/11/29.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation
import OSLog

public enum KeychainManager {
    
    /// Keychain에 데이터를 저장합니다.
    public static func set(_ value: Any?, forKey key: String) {
        guard let data = (value as AnyObject).data(using: String.Encoding.utf8.rawValue) else { return }
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecDuplicateItem {
            update(data, forKey: key)
        }
        debug(forKey: key, status: status, type: .set)
    }
    
    /// Keychain에서 데이터를 가져옵니다.
    public static func read(forKey key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ]
        
        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess { return nil }
        
        guard let exisingItems = item as? [String: Any],
              let itemData = exisingItems[kSecValueData as String] as? Data,
              let data = String(data: itemData, encoding: .utf8) else {
            return nil
        }
        
        return data
    }
    
    /// Keychain에 있는 데이터를 삭제합니다.
    public static func delete(forKey key: String) {
        let deleteQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        
        let status = SecItemDelete(deleteQuery as CFDictionary)
        debug(forKey: key, status: status, type: .delete)
    }
}

extension KeychainManager {
    
    /// Keychain의 데이터를 업데이트합니다.
    public static func update(_ value: Any, forKey key: String) {
        let previousQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        
        let updateQuery: [CFString: Any] = [kSecValueData: value]
        let status = SecItemUpdate(
            previousQuery as CFDictionary,
            updateQuery as CFDictionary
        )
        debug(forKey: key, status: status, type: .update)
    }
}

extension KeychainManager {
    
    public enum KeychainType: String {
        case set
        case read
        case update
        case delete
    }
    
    public static func debug(forKey key: String, status: OSStatus, type: KeychainType) {
        switch status {
        case errSecSuccess:
            os_log("\(key) \(type.rawValue) success")
        case errSecDuplicateItem:
            os_log("\(key) \(type.rawValue) duplicate")
        default:
            os_log("\(key) \(type.rawValue) fail")
        }
    }
}
