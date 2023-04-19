//
//  ProtocolWebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Арсений Убский on 09.03.2023.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

 protocol AuthViewControllerDelegate: AnyObject {
     func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
 }
