//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Арсений Убский on 24.04.2023.
//

import Foundation

public protocol ImagesListPresenterProtocol{
    var view: ImagesListViewControllerProtocol? { get set }
    func imageListCellDidTapLike(_ cell: ImagesListCell ,indexPath: IndexPath)
    func isLiked(indexPath: IndexPath) -> Bool
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    private var imagesListService = ImagesListService.shared
    weak var view: ImagesListViewControllerProtocol?
    
    func imageListCellDidTapLike(_ cell: ImagesListCell ,indexPath: IndexPath) {
        let photo = view?.photos[indexPath.row]
        UIBlockingProgressHUD.show() // блокируем UI на время запроса
        imagesListService.changeLike(photoId: photo?.id ?? "", isLike: photo?.isLiked ?? false) { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case.success:
                    self?.view?.photos = self?.imagesListService.photos ?? []
                    print("AAA")
                    cell.setIsLiked(isLiked: self?.view?.photos[indexPath.row].isLiked ?? false)
                    UIBlockingProgressHUD.dismiss()
                case.failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    self?.view?.showErrorLikeAlert(with: error)
                }
            }
        }
    }
    
    func isLiked(indexPath: IndexPath) -> Bool {
        return (imagesListService.photos[indexPath.row].isLiked == true)
    }
}
