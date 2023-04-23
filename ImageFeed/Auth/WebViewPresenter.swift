//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Арсений Убский on 23.04.2023.
//

import Foundation
import WebKit

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func removeUnsplashCookies()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
        let request = authHelper.authRequest()
        view?.load(request: request)
        didUpdateProgressValue(0)
        removeUnsplashCookies()
    }
    
    func removeUnsplashCookies() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                if record.displayName.contains("unsplash") {
                    dataStore.removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                    debugPrint("Record \(record) deleted")
                }
            }
        }
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
