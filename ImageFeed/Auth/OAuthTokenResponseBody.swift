//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Арсений Убский on 15.03.2023.
//

import Foundation

struct OAuthTokenResponseBody{
    var accessToken: String
    var tokenType: String
    var scope: String
    var createdAt: Int
}
