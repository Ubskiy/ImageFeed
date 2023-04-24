//
//  ProfileTests.swift
//  Image FeedTests
//
//  Created by Арсений Убский on 24.04.2023.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    
    func checkDidTapLike(){
        //given
        let presenter = ImagesListPresenterSpy()
        
        //when
        presenter.imageListCellDidTapLike(ImagesListCell(), indexPath: IndexPath())
        
        //then
        XCTAssertTrue(presenter.didTapLike)
    }
    
    func checkIsLiked() {
        let presenter = ImagesListPresenterSpy()
        
        XCTAssertTrue(presenter.isLiked(indexPath: IndexPath()))
    }
}

