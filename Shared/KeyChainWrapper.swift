//
//  KeyChain.swift
//  NordSecTest (iOS)
//
//  Created by Vitalii Kizlov on 06.05.2021.
//

import Foundation
import Security


struct KeychainWrapperError: Error {
    var message: String?
    var type: KeychainErrorType
    
    enum KeychainErrorType {
        case badData
        case servicesError
        case itemNotFound
        case unableToConvertToString
    }
    
    init(status: OSStatus, type: KeychainErrorType) {
        self.type = type
        if let errorMessage = SecCopyErrorMessageString(status, nil) {
            self.message = String(errorMessage)
        } else {
            self.message = "Status Code: \(status)"
        }
    }
    
    init(type: KeychainErrorType) {
        self.type = type
    }
    
    init(message: String, type: KeychainErrorType) {
        self.message = message
        self.type = type
    }
}

enum KeychainServiceType: String {
    case username, password, token
}

class KeychainWrapper {
    
    static let shared = KeychainWrapper()
    private init() {}
    
    private let account = "nord"
    
    func storeValueFor(service: KeychainServiceType, value: String) {
        guard let passwordData = value.data(using: .utf8) else {
            print("Error converting value to data.")
            return
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service.rawValue,
            kSecValueData as String: passwordData
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            break
        default:
            print(KeychainWrapperError(status: status, type: .servicesError))
        }
    }
    
    func getValueFor(service: KeychainServiceType) -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service.rawValue,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status != errSecItemNotFound else {
            print(KeychainWrapperError(type: .itemNotFound))
            return ""
        }
        guard status == errSecSuccess else {
            print(KeychainWrapperError(status: status, type: .servicesError))
            return ""
        }
        guard let existingItem = item as? [String: Any],
              let valueData = existingItem[kSecValueData as String] as? Data,
              let value = String(data: valueData, encoding: .utf8)
        else {
            print(KeychainWrapperError(type: .unableToConvertToString))
            return ""
        }
        
        return value
    }
    
    func deleteValueFor(service: KeychainServiceType) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service.rawValue
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            print(KeychainWrapperError(status: status, type: .servicesError))
            return
        }
    }
    
    public func cleanStorage() {
        deleteValueFor(service: .username)
        deleteValueFor(service: .password)
        deleteValueFor(service: .token)
    }
}
