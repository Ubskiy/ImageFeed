import Foundation

extension URLRequest {
    enum HTTPMethod: String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case DELETE = "DELETE"
    }
    
    static func makeHTTPRequest(
        path: String,
        baseURL: URL,
        httpMethod: HTTPMethod = .GET
    ) -> URLRequest {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            return URLRequest(url:baseURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        return request
    }
    
    static func makeHTTPRequest(
        path: String,
        queryItems: [URLQueryItem],
        baseURL: URL
    ) -> URLRequest {
        guard let url = URL(string: path, relativeTo: baseURL) else {return URLRequest(url:baseURL)}
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return URLRequest(url:baseURL)
        }
        var urlComponent = urlComponents
        urlComponent.queryItems = queryItems
        guard let urlComponentUrl = urlComponent.url else {
            return URLRequest(url:baseURL)
        }
        return URLRequest(url: urlComponentUrl)
    }
    
    mutating func addAuthorizationHeader(_ token: String) {
        self.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}
