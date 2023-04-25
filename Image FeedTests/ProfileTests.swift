//
//  ProfileTests.swift
//  Image FeedTests
//
//  Created by Арсений Убский on 24.04.2023.
//

@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    func checkLogout(){
        //given
        let presenter = ProfilePresenterSpy()
        
        //when
        presenter.logout()
        
        //then
        XCTAssertTrue(presenter.logoutCheck)
    }
    
    func checkCleanServices(){
        //given
        let presenter = ProfilePresenterSpy()
        
        //when
        presenter.cleanServices()
        
        //then
        XCTAssertTrue(presenter.cleanServicesCheck)
    }
    
    func checkDeleteStorageToken(){
        //given
        let presenter = ProfilePresenterSpy()
        
        //when
        presenter.deleteStorageToken()
        
        //then
        XCTAssertTrue(presenter.deleteTokenCheck)
    }
    
}
