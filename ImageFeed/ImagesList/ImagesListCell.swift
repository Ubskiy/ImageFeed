//
//  ImagesList.swift
//  ImageFeed
//
//  Created by Арсений Убский on 31.01.2023.
//
import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet var pictureView: UIImageView!
    @IBOutlet var labelView: UILabel!
    @IBOutlet var likeButtonView: UIButton!
    
    static let reuseIdentifier = "ImagesListCell"
    
}
