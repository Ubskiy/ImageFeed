//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Арсений Убский on 27.03.2023.
//

import Foundation

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String
}

final class ProfileService {
    static let shared = ProfileService() //синглтон
    private(set) var profile: Profile?
    
    private struct ProfileResult: Decodable {
        let id: String
        let username: String
        let firstname: String?
        let lastname: String?
        let bio: String?
    }
    
    func clean() {
        profile = nil
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        let request = createGetProfileRequest(accessToken: token)
        let task = URLSession.shared
            .objectTask(request: request) { [weak self] (result: Result<ProfileResult, Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case let .success(profileResult):
                        let profile = ProfileService.profileFactory(profileResult)
                        self?.profile = profile
                        completion(.success(profile))
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            }
        task.resume()
    }
    
    private func createGetProfileRequest(accessToken: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/me", baseURL: Constants.api)
            request.addAuthorizationHeader(accessToken)
            return request
        }
    
    private static func profileFactory(_ result: ProfileResult) -> Profile {
        Profile(
            username: result.username,
            name: "\(result.firstname.orEmpty()) \(result.lastname.orEmpty())",
            loginName: "@\(result.username)",
            bio: result.bio.orEmpty()
        )
    }
}
