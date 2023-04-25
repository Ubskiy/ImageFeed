//
//  Constants.swift
//  ImageFeed
//
//  Created by Арсений Убский on 07.03.2023.
//
import Foundation

extension URL: ExpressibleByStringLiteral { // extension чтобы избегать force unwrap в URL
    public init(stringLiteral value: StaticString) {
        self = URL(string: "\(value)").require(hint: "Invalid URL string literal: \(value)")
    }
}

let myAccessKey = "LtVXVKl614O1UDNGygCjiuFih-8r4rBQUinkIo_m8Ns"
let mySecretKey = "dGXWJgOSjj6Ho0iyaZLxCGnEfvrWCKV3_79ojJ-6j_4"
let myRedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let myAccessScope = "public+read_user+write_likes"
let myDefaultBaseURL: URL = "https://unsplash.com"
let myApi: URL = "https://api.unsplash.com/"
let myUnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let authURLString: String
    let defaultBaseURL: URL
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.authURLString = authURLString
        self.defaultBaseURL = defaultBaseURL
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: myAccessKey,
                                 secretKey: mySecretKey,
                                 redirectURI: myRedirectURI,
                                 accessScope: myAccessScope,
                                 authURLString: myUnsplashAuthorizeURLString,
                                 defaultBaseURL: myDefaultBaseURL)
    }
}
