//
//  Image_FeedTests.swift
//  Image FeedTests
//
//  Created by Арсений Убский on 13.04.2023.
//

@testable import ImageFeed
import XCTest

final class ImagesListServiceTests: XCTestCase {
    func testFetchPhotos() {
        let service = ImagesListService()
        let storageToken = OAuth2TokenStorage()
        
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification,
            object: nil,
            queue: .main) { _ in
                expectation.fulfill()
            }
        guard let token = storageToken.token else {return}
        service.fetchPhotosNextPage(token) {_ in}
        wait(for: [expectation], timeout: 10)
        
        XCTAssertEqual(service.photos.count, 10)
    }
}
