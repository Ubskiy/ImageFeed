//
//  ImagesList.swift
//  ImageFeed
//
//  Created by Арсений Убский on 31.01.2023.
//
import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet var pictureImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    static let reuseIdentifier = "ImagesListCell"
    
}
