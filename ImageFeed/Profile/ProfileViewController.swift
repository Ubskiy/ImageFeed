//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Арсений Убский on 07.02.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private var profileImageSize: CGFloat = 70
    private let profileImageService = ProfileImageService.shared
    private let webView = WebViewViewController()
    private let storageToken = OAuth2TokenStorage()
    var animationLayers = Set<CALayer>()
    
    private lazy var personImage: UIImageView = {
             let personImage = UIImageView()
             personImage.translatesAutoresizingMaskIntoConstraints = false
             personImage.image = ProfileViewController.getPersonImage()
             personImage.contentMode = .scaleAspectFit
             personImage.layer.cornerRadius = profileImageSize / 2
             personImage.clipsToBounds = true
             return personImage
         }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "SFProDisplay-Bold", size: 23)
        nameLabel.textColor = .ypWhite
        nameLabel.backgroundColor = .ypBlack
        return nameLabel
    }()
    
    private lazy var tagLabel: UILabel = {
        let tagLabel = UILabel()
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.font = UIFont(name: "YandexSansText-Regular", size: 13)
        tagLabel.textColor = .ypGray
        tagLabel.backgroundColor = .ypBlack
        return tagLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont(name: "YandexSansText-Regular", size: 13)
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.backgroundColor = .ypBlack
        return descriptionLabel
    }()
    
    private func updateAvatar() {                                   // 8
        if let avatarUrl = profileImageService.avatarURL,
           let imageUrl = URL(string: avatarUrl) {
            personImage.kf.indicatorType = .activity
            personImage.kf.setImage(
                with: imageUrl,
                placeholder: personImage.image,
                options: [.cacheSerializer(FormatIndicatedCacheSerializer.png), .cacheMemoryOnly])
        }
        }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //Верстка кодом
        configImage(imageView: personImage)
        
        let button = UIButton.systemButton(
                    with: UIImage(named: "ExitButton")!,
                    target: self,
                    action: #selector(Self.didTapLogoutButton)
                )
        configButton(button: button, imageView: personImage)
        configNameLabel(nameLabel: nameLabel, imageView: personImage)
        configTagLabel(tagLabel: tagLabel,imageView: personImage ,nameLabel: nameLabel)
        configDescriptionLabel(descriptionLabel: descriptionLabel,imageView: personImage,tagLabel: tagLabel)
        view.backgroundColor = .ypBlack
        
        NSLayoutConstraint.activate([
        personImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        personImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
        personImage.widthAnchor.constraint(equalToConstant: 70),
        personImage.heightAnchor.constraint(equalToConstant: 70),
        button.centerYAnchor.constraint(equalTo: personImage.centerYAnchor),
        button.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -26),
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 56),
        nameLabel.topAnchor.constraint(equalTo: personImage.bottomAnchor, constant: 8),
        nameLabel.leadingAnchor.constraint(equalTo: personImage.leadingAnchor),
        nameLabel.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor, constant: 124),
        tagLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
        tagLabel.leadingAnchor.constraint(equalTo: personImage.leadingAnchor),
        tagLabel.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor, constant: 260),
        descriptionLabel.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 8),
        descriptionLabel.leadingAnchor.constraint(equalTo: personImage.leadingAnchor),
        descriptionLabel.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor, constant: 282)
        ])
        
        guard let profile = profileService.profile else {
            return
        }
        updateProfileDetails(profile: profile)
                
        profileImageServiceObserver = NotificationCenter.default
                   .addObserver(
                       forName: ProfileImageService.DidChangeNotification,
                       object: nil,
                       queue: .main
                   ) { [weak self] _ in
                       guard let self = self else { return }
                       self.updateAvatar()
                   }
               updateAvatar()
    }
    
    private func configImage(imageView: UIImageView){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.backgroundColor = .ypBlack
    }
    
    private func configButton(button: UIButton, imageView: UIImageView){
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
    }
    
    private func configNameLabel(nameLabel: UILabel, imageView: UIImageView){
        nameLabel.text = "Екатерина Новикова"
        view.addSubview(nameLabel)
    }
    
    private func configTagLabel(tagLabel: UILabel, imageView: UIImageView, nameLabel: UILabel){
        tagLabel.text = "@ekaterina_nov"
        view.addSubview(tagLabel)
    }
    
    private func configDescriptionLabel(descriptionLabel: UILabel, imageView: UIImageView, tagLabel: UILabel){
        descriptionLabel.text = "Hello, world!"
        view.addSubview(descriptionLabel)
    }
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        tagLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private static func getPersonImage() -> UIImage {
        let systemName = "person.crop.circle.fill"
        if #available(iOS 15.0, *) {
            let config = UIImage.SymbolConfiguration(paletteColors: [.ypWhite!, .ypGray!])
            return UIImage(systemName: systemName, withConfiguration: config)!
        } else {
            return UIImage(systemName: systemName)!
        }
    }
    
    private func logout() {
        storageToken.deleteToken()
        webView.removeUnsplashCookies()
        cleanServices()
        tabBarController?.dismiss(animated: true)
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration") }
        window.rootViewController = SplashViewController()
    }
    
    private func cleanServices() {
        ImagesListService.shared.clean()
        ProfileService.shared.clean()
        ProfileImageService.shared.clean()
    }
    
    @objc
    private func didTapLogoutButton(){
        OAuth2TokenStorage().token = nil
        
        let alert = UIAlertController(
            title: "Выход из учетной записи",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            self.logout()
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
