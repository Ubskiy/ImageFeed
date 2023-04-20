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
        case largeImageUrl = "full"
    }
}

struct LikePhotoResult: Decodable {
    let photo: PhotoResult?
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
    
    func clean() {
        photos = []
        lastLoadedPage = nil
        task?.cancel()
        task = nil
    }
    
    func fetchPhotosNextPage(_ token: String, completion: @escaping (Result<[Photo], Error>) -> Void) {
        assert(Thread.isMainThread)// Главный поток
        guard task == nil, // Проверяем существует ли текущий запрос
              let token = storageToken.token else { return } // Проверяем наличие токена авторизации
        let page = lastLoadedPage.map { $0 + 1 } ?? 1 //Если 1-ая загруженная страница, то 1, иначе +1
        guard let request = fetchImagesListRequest(token, page: String(page), perPage: perPage) else {
            return
        }
        let task = URLSession.shared.objectTask(request: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case let .success(photoResults):
                    for photoResult in photoResults {
                        var noRepeatPhotos: Bool = true
                        let photoToAppend = self.convert(photoResult)
                        for photo in self.photos {
                            if photo.id == photoToAppend.id {
                                noRepeatPhotos = false
                            }
                        }
                        if noRepeatPhotos {
                            self.photos.append(photoToAppend)
                            self.lastLoadedPage = page
                            NotificationCenter.default // постим нотификацию
                                .post(
                                    name: ImagesListService.DidChangeNotification,
                                    object: self,
                                    userInfo: ["Images" : self.photos])
                            completion(.success(self.photos))
                        }
                    }
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
    
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread) //Главный поток
        task?.cancel()
        guard let token = storageToken.token else { return } //проверяем на наличие токена авторизации
        let request: URLRequest? = isLike
        ? deleteLikeRequest(token, photoId: photoId) // Если стоял лайк - убираем
        : postLikeRequest(token, photoId: photoId) // Если не было лайка - Ставим
        
        // MARK - запрос в сеть
        guard let request = request else { return }
        let session = URLSession.shared
        let task = session.objectTask(request: request) { [weak self] (result: Result<LikePhotoResult, Error>) in
            guard let self = self else { return }
            self.task = nil
            switch result {
            case .success(let photoResult):
                let isLiked = photoResult.photo?.isLiked ?? false
                if let index = self.photos.firstIndex(where: { $0.id == photoResult.photo?.id }) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        width: photo.width,
                        height: photo.height,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: isLiked
                    )
                    self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    private func postLikeRequest(_ token: String, photoId: String) -> URLRequest? {
        var requestPost = URLRequest.makeHTTPRequest(
            path: "photos/\(photoId)/like",
            baseURL: Constants.api,
            httpMethod: .POST
        )
        requestPost.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return requestPost
    }
    
    private func deleteLikeRequest(_ token: String, photoId: String) -> URLRequest? {
        var requestDelete = URLRequest.makeHTTPRequest(
            path: "photos/\(photoId)/like",
            baseURL: Constants.api,
            httpMethod: .DELETE
        )
        requestDelete.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return requestDelete
    }
}

extension Array { // extension для замены фотографии новой фотографии в методе changeLike
    func withReplaced(itemAt: Int, newValue: Photo) -> [Photo] {
        var photos = ImagesListService.shared.photos
        photos[itemAt] = newValue
        return photos
    }
}
