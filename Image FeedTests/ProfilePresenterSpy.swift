//
//  ProfilePresenterSpy.swift
//  Image FeedTests
//
//  Created by Арсений Убский on 24.04.2023.
//
import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfileViewPresenterProtocol  {
    var logoutCheck: Bool = false
    var cleanServicesCheck: Bool = false
    var deleteTokenCheck: Bool = false
    weak var view: ProfileViewControllerProtocol?
    
    
    func logout(){
        logoutCheck = true
    }
    
    func cleanServices(){
        cleanServicesCheck = true
    }
    
    func deleteStorageToken(){
        deleteTokenCheck = true
    }
}
