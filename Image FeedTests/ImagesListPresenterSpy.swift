//
//  ImagesListViewControllerSpy.swift
//  Image FeedTests
//
//  Created by Арсений Убский on 24.04.2023.
//
import ImageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var didTapLike = false
    
    
    func imageListCellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath) {
        didTapLike = true
    }
    
    func isLiked(indexPath: IndexPath) -> Bool {
        return true
    }
}
