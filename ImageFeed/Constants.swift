//
//  Constants.swift
//  ImageFeed
//
//  Created by Арсений Убский on 07.03.2023.
//
import Foundation
struct Constants {
    static let accessKey = "LtVXVKl614O1UDNGygCjiuFih-8r4rBQUinkIo_m8Ns"
    static let secretKey = "dGXWJgOSjj6Ho0iyaZLxCGnEfvrWCKV3_79ojJ-6j_4"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://unsplash.com")!
    static let api = URL(string: "https://api.unsplash.com")!
}
