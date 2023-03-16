//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Арсений Убский on 08.03.2023.
//
import UIKit

final class AuthViewController: UIViewController {
    // MARK: - OAuth2Service
    private let oAuth2Service: OAuth2Service = OAuth2Service() //приватная сервиса авторизации
    
    let ShowWebViewSegueIdentifier = "ShowWebView"
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
        
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
