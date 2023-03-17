//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Арсений Убский on 15.03.2023.
//

import Foundation
final class OAuth2TokenStorage{
    private let key = "authToken"
    private let userDefaults = UserDefaults.standard //переменная для работы с userDefaults
    private (set) var token: String? {
            get {
                let authToken = userDefaults.string(forKey: key)
                return authToken
            }
            set {
                userDefaults.set(newValue, forKey: key)
    } }
    
    init(_ newValue: String?)
    {
        token = newValue
    }
    
    init()
    {
        self.token = token
    }
}
