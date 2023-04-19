import Foundation

final class ProfileImageService {
    private let oauth2TokenStorage = OAuth2TokenStorage()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService() //синглтон
    private (set) var avatarURL: String?
    
    private struct UserResult: Decodable {
            let id: String
            let profile_image: ProfileImage
        }
    
    private struct ProfileImage: Decodable {
             let small: String
         }
    
    func clean() {
        avatarURL = nil
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
             guard let token = oauth2TokenStorage.token else {
                 assertionFailure("No token")
                 return
             }
             let request = createGetProfileImageRequest(username: username, token: token)
             let task = URLSession.shared
                     .objectTask(request: request) { [weak self] (result: Result<UserResult, Error>) in
                         DispatchQueue.main.async {
                             switch result {
                             case let .success(userResult):
                                 let imageURL = userResult.profile_image.small
                                 self?.avatarURL = imageURL
                                 completion(.success(imageURL))
                                 NotificationCenter.default.post(
                                         name: Self.DidChangeNotification,
                                         object: self,
                                         userInfo: ["URL": imageURL]
                                 )
                             case let .failure(error):
                                 completion(.failure(error))
                             }
                         }
                     }
             task.resume()
         }
    
    private func createGetProfileImageRequest(username: String, token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", baseURL: Constants.api)
             request.addAuthorizationHeader(token)
             return request
         }
}
