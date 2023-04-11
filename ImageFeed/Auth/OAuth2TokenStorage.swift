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

    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: key)
        }
        set {
            if let token = newValue {
                guard KeychainWrapper.standard.set(token, forKey: key) else {
                    assertionFailure("Failed to save token")
                    return
                }
            } else {
                KeychainWrapper.standard.removeObject(forKey: key)
            }
        }
    }
}
