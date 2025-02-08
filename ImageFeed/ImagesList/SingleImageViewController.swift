//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Алина on 03.02.2025.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK: - Public properties
    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else { return }
            
            imageView.image = image
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        guard let image else { return }
        imageView.image = image
        imageView.frame.size = image.size
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    // MARK: - Private Functions
    private func rescaleAndCenterImageInScrollView(image: UIImage){
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        imageView.image = image
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        centerImageIfNeeded(scrollView, visibleRectSize: visibleRectSize)
    }
    
    private func centerImageIfNeeded(_ scrollView: UIScrollView, visibleRectSize: CGSize) {
        let newContentSize = scrollView.contentSize
        let x = max((visibleRectSize.width - newContentSize.width) / 2, 0)
        let y = max((visibleRectSize.height - newContentSize.height) / 2, 0)
        scrollView.contentInset = UIEdgeInsets(top: y, left: x,bottom: y, right: x)
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extension
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        let visibleRectSize = scrollView.bounds.size
        centerImageIfNeeded(scrollView, visibleRectSize: visibleRectSize)
    }
}
