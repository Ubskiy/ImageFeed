//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Арсений Убский on 12.04.2023.
//
import Foundation

struct Photo {
    let id: String
    let width: CGFloat
    let height: CGFloat
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String?
    let largeImageURL: String?
    let isLiked: Bool
}

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let welcomeDescription: String?
    let isLiked: Bool?
    let urls: ImageUrlsResult?
    let width: CGFloat
    let height: CGFloat
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case welcomeDescription = "description"
        case isLiked = "liked_by_user"
        case urls = "urls"
        case width = "width"
        case height = "height"
    }
}

struct ImageUrlsResult: Decodable {
    let thumbImageUrl: String?
    let largeImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case thumbImageUrl = "thumb"
        case largeImageUrl = "large"
    }
}

final class ImagesListService {
    static let shared = ImagesListService()
    private (set) var photos: [Photo] = []
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let storageToken = OAuth2TokenStorage()
    private var perPage = "10"
    private let dateFormatter = ISO8601DateFormatter()
    
    func updatePhotos(_ photos: [Photo]){
        self.photos = photos
    }
    
    
    
    func fetchPhotosNextPage(_ token: String, completion: @escaping (Result<[Photo], Error>) -> Void) {
        assert(Thread.isMainThread)// Главный поток
        guard task == nil else {return} // Проверяем существует ли текущий запрос
        guard let token = storageToken.token else { return } // Проверяем наличие токена авторизации
        let page = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1 //Если 1-ая загруженная страница, то 1, иначе +1
        guard let request = fetchImagesListRequest(token, page: String(page), perPage: perPage) else {
            return
        }
        let task = URLSession.shared.objectTask(request: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case let .success(photoResults):
                    for photoResult in photoResults {
                        let photoToAppend = self.convert(photoResult)
                        self.photos.append(photoToAppend) // Добавление в конец массива photos
                    }
                    self.lastLoadedPage = page
                    NotificationCenter.default // постим нотификацию
                        .post(
                            name: ImagesListService.DidChangeNotification,
                            object: self,
                            userInfo: ["Images" : self.photos])
                    completion(.success(self.photos))
                case let .failure(error):
                    print(String(describing: error))
                    completion(.failure(error))
                }
                self.task = nil // Обьявляем, что выполнение запроса закончено
            }
        }
        self.task = task
        task.resume()
    }
    
    private func fetchImagesListRequest(_ token: String, page: String, perPage: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "/photos?page=\(page)&&per_page=\(perPage)",
            baseURL: URL(string: "\(Constants.api)")!,
            httpMethod: .GET
            )
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func convert(_ photoResult: PhotoResult) -> Photo {

        return Photo.init(id: photoResult.id,
                          width: CGFloat(photoResult.width),
                          height: CGFloat(photoResult.height),
                          createdAt: self.dateFormatter.date(from:photoResult.createdAt ?? ""),
                          welcomeDescription: photoResult.welcomeDescription,
                          thumbImageURL: photoResult.urls?.thumbImageUrl,
                          largeImageURL: photoResult.urls?.largeImageUrl,
                          isLiked: photoResult.isLiked ?? false)
    }
}
