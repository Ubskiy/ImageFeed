//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Арсений Убский on 24.04.2023.
//

import Foundation

public protocol ProfileViewPresenterProtocol {
    func logout()
    func cleanServices()
    func deleteStorageToken()
    var view: ProfileViewControllerProtocol? { get set }
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    // MARK - lets and vars
    private let webView = WebViewViewController()
    private let storageToken = OAuth2TokenStorage()
    weak var view: ProfileViewControllerProtocol?
    
    // MARK - functions
    func logout(){
        storageToken.deleteToken()
        cleanServices()
    }
    
    func cleanServices(){
        ImagesListService.shared.clean()
        ProfileService.shared.clean()
        ProfileImageService.shared.clean()
    }
    
    func deleteStorageToken() {
        storageToken.deleteToken()
    }
}
