//
//  SessionService.swift
//  WeatherApp
//
//  Created by Egor Syrtcov on 2/26/21.
//

import Foundation
import Security

final class SessionService {
    
    private enum StorageKey: String {
        case email
        case password
    }

    func save(credential: Credential) {
        let _ = save(key: StorageKey.email.rawValue, data: credential.email.data(using: .utf8)!)
        let _ = save(key: StorageKey.password.rawValue, data: credential.password.data(using: .utf8)!)
    }
    
    func clearCredential() {
        remove(key: StorageKey.email.rawValue)
        remove(key: StorageKey.password.rawValue)
    }
    
    func readCredential() -> Credential? {
        guard let emailData = load(key: StorageKey.email.rawValue),
              let passwordData = load(key: StorageKey.password.rawValue) else { return nil }
        guard let email = String(data: emailData, encoding: .utf8),
              let password = String(data: passwordData, encoding: .utf8) else { return nil }
        return Credential(email: email, password: password)
    }
}

private extension SessionService {
    func save(key: String, data: Data) -> OSStatus {
        let query = [
          kSecClass: kSecClassGenericPassword,
          kSecAttrAccount: key,
          kSecValueData: data] as [String: Any]
        SecItemDelete(query as CFDictionary)
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    func remove(key: String) {
        let query = [
          kSecClass: kSecClassGenericPassword,
          kSecAttrAccount: key] as [String: Any]
        SecItemDelete(query as CFDictionary)
    }
    
    func load(key: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne] as [String: Any]
        var dataTypeRef: AnyObject? = nil
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        guard status == noErr else { return nil }
        return dataTypeRef as! Data?
    }
}
