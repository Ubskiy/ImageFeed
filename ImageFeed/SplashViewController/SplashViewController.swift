//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Арсений Убский on 17.03.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    private let progressHud = UIBlockingProgressHUD()
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private lazy var logoImage: UIImageView = {
        let logoImage = UIImageView()
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.image = UIImage(named: "splash_screen_logo")
        logoImage.contentMode = .scaleAspectFit
        logoImage.layer.masksToBounds = true
        return logoImage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        view.addSubview(logoImage)
        NSLayoutConstraint.activate([
            logoImage.widthAnchor.constraint(equalToConstant: 75),
            logoImage.heightAnchor.constraint(equalToConstant: 77.68),
            logoImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            logoImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = oauth2TokenStorage.token {
            fetchProfileAndSwitchScreen(token: token)
        } else {
            showAuthViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func showAuthViewController() {
        guard let authViewController: AuthViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
        else {
            return
        }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        self.present(authViewController, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func fetchProfileAndSwitchScreen(_ token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let profile):
                self.profileImageService.fetchProfileImageURL(username: profile.username) { _ in
                }
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure(let error):
                debugPrint(error.localizedDescription)
                UIBlockingProgressHUD.dismiss()
                SplashViewController.showNetworkErrorAlert(self)
            }
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        UIBlockingProgressHUD.show()
        fetchOAuthToken(code)
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let token):
                self.oauth2TokenStorage.token = token
                self.fetchProfileAndSwitchScreen(token: token)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                debugPrint(error.localizedDescription)
                UIBlockingProgressHUD.dismiss()
                SplashViewController.showNetworkErrorAlert(self.presentedViewController ?? self)
                break
            }
        }
    }
    
    private func fetchProfileAndSwitchScreen(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profileImageService.fetchProfileImageURL(username: profile.username) { _ in
                }
                self.switchToTabBarController()
            case .failure(let error):
                debugPrint(error.localizedDescription)
                SplashViewController.showNetworkErrorAlert(self.presentedViewController ?? self)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}

extension UIViewController {
    static func showNetworkErrorAlert(_ vc: UIViewController) {
        let alert = UIAlertController(title: "Что-то пошло не так(",
                                      message: "Не удалось войти в систему",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}



