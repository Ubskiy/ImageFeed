//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Арсений Убский on 10.02.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage!{ didSet {
        guard isViewLoaded else { return } // 1
        singleImageView.image = image // 2
        }
    }
    
    @IBOutlet var singleImageView: UIImageView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            singleImageView.image = image
        }
}
