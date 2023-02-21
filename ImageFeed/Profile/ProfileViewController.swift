//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Арсений Убский on 07.02.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var linkLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var logoutButton: UIButton!
    @IBAction func logoutButtonDidTap(_ sender: Any) {
    }
}
