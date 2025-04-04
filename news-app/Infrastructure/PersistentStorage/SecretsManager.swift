//
//  SecretsManager.swift
//  news-app
//
//  Created by Georgius Yoga on 4/4/25.
//

import Foundation
import Security

final class SecretsManager {

    enum APIKey: String {
        case news = "NEWS_API_KEY"
    }

    func getKeyandSaveToKeychain(key: APIKey) -> String {
        if let apiKey = getAPIKey(for: key) {
            saveToKeychain(key: key.rawValue, value: apiKey)
            return getFromKeychain(key: key.rawValue) ?? ""
        }
        return ""
    }

    private func getAPIKey(for name: APIKey) -> String? {
        // Find the path to Secrets.plist inside the bundle
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path),
           let apiKey = dict[name.rawValue] as? String {
            return apiKey
        }
        return nil
    }

    private func saveToKeychain(key: String, value: String) {
        let data = value.data(using: .utf8)!

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)

        if status == errSecSuccess {
            printIfDebug("API Key saved successfully in Keychain!")
        } else {
            printIfDebug("Failed to save API Key: \(status)")
        }
    }

    private func getFromKeychain(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        } else {
            printIfDebug("API Key not found in Keychain or error: \(status)")
            return nil
        }
    }

}
