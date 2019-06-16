//
//  PhotoViewController.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 16/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit

open class PhotoViewController: UIViewController, UIScrollViewDelegate {
    var photo: PhotoViewable
    
    var longPressGestureHandler: ((UILongPressGestureRecognizer) -> ())?
    
    lazy private(set) var scalingImageView: ScalingImageView = {
        return ScalingImageView()
    }()
    
    lazy private(set) var doubleTapGestureRecognizer: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(PhotoViewController.handleDoubleTapWithGestureRecognizer(_:)))
        gesture.numberOfTapsRequired = 2
        return gesture
    }()
    
    lazy private(set) var longPressGestureRecognizer: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(PhotoViewController.handleLongPressWithGestureRecognizer(_:)))
        return gesture
    }()
    
    lazy private(set) var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    public init(photo: PhotoViewable) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        scalingImageView.delegate = nil
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        scalingImageView.delegate = self
        scalingImageView.frame = view.bounds
        scalingImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scalingImageView)
        
        view.addSubview(activityIndicator)
        activityIndicator.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        activityIndicator.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        activityIndicator.sizeToFit()
        
        view.addGestureRecognizer(doubleTapGestureRecognizer)
        view.addGestureRecognizer(longPressGestureRecognizer)
        
        if let image = photo.image {
            scalingImageView.image = image
            activityIndicator.stopAnimating()
        } else if let thumbnailImage = photo.thumbnailImage {
            scalingImageView.image = thumbnailImage
            activityIndicator.stopAnimating()
            loadFullSizeImage()
        } else {
            loadThumbnailImage()
        }
        
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scalingImageView.frame = view.bounds
    }
    
    private func loadThumbnailImage() {
        view.bringSubviewToFront(activityIndicator)
        photo.loadThumbnailImageWithCompletionHandler { [weak self] (image, error) -> () in
            
            let completeLoading = {
                self?.scalingImageView.image = image
                if image != nil {
                    self?.activityIndicator.stopAnimating()
                }
                self?.loadFullSizeImage()
            }
            
            if Thread.isMainThread {
                completeLoading()
            } else {
                DispatchQueue.main.async(execute: { () -> Void in
                    completeLoading()
                })
            }
        }
    }
    
    private func loadFullSizeImage() {
        view.bringSubviewToFront(activityIndicator)
        self.photo.loadImageWithCompletionHandler({ [weak self] (image, error) -> () in
            let completeLoading = {
                self?.activityIndicator.stopAnimating()
                self?.scalingImageView.image = image
            }
            
            if Thread.isMainThread {
                completeLoading()
            } else {
                DispatchQueue.main.async(execute: { () -> Void in
                    completeLoading()
                })
            }
        })
    }
    
    @objc private func handleLongPressWithGestureRecognizer(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            longPressGestureHandler?(recognizer)
        }
    }
    
    @objc private func handleDoubleTapWithGestureRecognizer(_ recognizer: UITapGestureRecognizer) {
        let pointInView = recognizer.location(in: scalingImageView.imageView)
        var newZoomScale = scalingImageView.maximumZoomScale
        
        if scalingImageView.zoomScale >= scalingImageView.maximumZoomScale || abs(scalingImageView.zoomScale - scalingImageView.maximumZoomScale) <= 0.01 {
            newZoomScale = scalingImageView.minimumZoomScale
        }
        
        let scrollViewSize = scalingImageView.bounds.size
        let width = scrollViewSize.width / newZoomScale
        let height = scrollViewSize.height / newZoomScale
        let originX = pointInView.x - (width / 2.0)
        let originY = pointInView.y - (height / 2.0)
        
        let rectToZoom = CGRect(x: originX, y: originY, width: width, height: height)
        scalingImageView.zoom(to: rectToZoom, animated: true)
    }
    
    // MARK:- UIScrollViewDelegate
    
    open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scalingImageView.imageView
    }
    
    open func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.panGestureRecognizer.isEnabled = true
    }
    
    open func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        // There is a bug, especially prevalent on iPhone 6 Plus, that causes zooming to render all other gesture recognizers ineffective.
        // This bug is fixed by disabling the pan gesture recognizer of the scroll view when it is not needed.
        if (scrollView.zoomScale == scrollView.minimumZoomScale) {
            scrollView.panGestureRecognizer.isEnabled = false;
        }
    }
}
