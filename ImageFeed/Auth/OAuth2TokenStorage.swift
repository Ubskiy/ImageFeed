//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Арсений Убский on 15.03.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let key = "authToken"
    private let keychainStorage = KeychainWrapper.standard

    var token: String? {
        get {
            keychainStorage.string(forKey: key)
        }
        set {
            if let token = newValue {
                guard keychainStorage.set(token, forKey: key) else {
                    assertionFailure("Failed to save token")
                    return
                }
            } else {
                keychainStorage.removeObject(forKey: key)
            }
        }
    }
    
    func deleteToken() {
        keychainStorage.removeAllKeys()
    }
}
