//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Арсений Убский on 10.02.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var singleImageView: UIImageView!
    
    var imageURL: URL! {
        didSet {
            guard isViewLoaded else {return}
            setImage()
        }
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 1.25
            setImage()
        guard let image = singleImageView.image else {return}
            rescaleAndCenterImageInScrollView(image: image)
        }
    
    
    @IBAction private func didTapBackButton() {
            dismiss(animated: true, completion: nil)
        }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        let share = UIActivityViewController(
            activityItems: [singleImageView.image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    private func setImage() {
        UIBlockingProgressHUD.show()
        singleImageView.kf.setImage(with: imageURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showAlert()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Попробовать ещё раз?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Не надо", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { action in
            self.setImage()
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        singleImageView
    }
    
}
