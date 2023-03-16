//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Арсений Убский on 07.02.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    private var nameLabel: UILabel?
    private var tagLabel: UILabel?
    private var decriptionLabel: UILabel?
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //Верстка кодом
        let profileImage = UIImage(named: "UserPicture")
        let imageView = UIImageView(image: profileImage)
        configImage(imageView: imageView)
        
        let button = UIButton.systemButton(
                    with: UIImage(named: "ExitButton")!,
                    target: self,
                    action: #selector(Self.didTapLogoutButton)
                )
        configButton(button: button, imageView: imageView)
        
        let nameLabel = UILabel()
        configNameLabel(nameLabel: nameLabel, imageView: imageView)
        
        let tagLabel = UILabel()
        configTagLabel(tagLabel: tagLabel,imageView: imageView ,nameLabel: nameLabel)
        
        let descriptionLabel = UILabel()
        configDescriptionLabel(descriptionLabel: descriptionLabel,imageView: imageView,tagLabel: tagLabel)
        
        NSLayoutConstraint.activate([
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
        imageView.widthAnchor.constraint(equalToConstant: 70),
        imageView.heightAnchor.constraint(equalToConstant: 70),
        button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
        button.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -26),
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 56),
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
        nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
        nameLabel.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor, constant: 124),
        tagLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
        tagLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
        tagLabel.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor, constant: 260),
        descriptionLabel.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 8),
        descriptionLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
        descriptionLabel.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor, constant: 282)
        ])
        
        self.nameLabel = nameLabel
        self.tagLabel = tagLabel
        self.decriptionLabel = descriptionLabel
    }
    
    private func configImage(imageView: UIImageView){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.layer.cornerRadius = 61
        imageView.backgroundColor = .ypBlack
    }
    
    private func configButton(button: UIButton, imageView: UIImageView){
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
    }
    
    private func configNameLabel(nameLabel: UILabel, imageView: UIImageView){
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont(name: "SFProDisplay-Bold", size: 23)
        nameLabel.textColor = .ypWhite
        nameLabel.backgroundColor = .ypBlack
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
    }
    
    private func configTagLabel(tagLabel: UILabel, imageView: UIImageView, nameLabel: UILabel){
        tagLabel.text = "@ekaterina_nov"
        tagLabel.font = UIFont(name: "YandexSansText-Regular", size: 13)
        tagLabel.textColor = .ypGray
        tagLabel.backgroundColor = .ypBlack
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tagLabel)
    }
    
    private func configDescriptionLabel(descriptionLabel: UILabel, imageView: UIImageView, tagLabel: UILabel){
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.font = UIFont(name: "YandexSansText-Regular", size: 13)
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.backgroundColor = .ypBlack
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
    }
    
    @objc
    private func didTapLogoutButton(){}
}
