//
//  ScalingImageView.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 16/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit
private func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}


class ScalingImageView: UIScrollView {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: self.bounds)
        self.addSubview(imageView)
        return imageView
    }()
    
    var image: UIImage? {
        didSet {
            updateImage(image)
        }
    }
    
    override var frame: CGRect {
        didSet {
            updateZoomScale()
            centerScrollViewContents()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageScrollView()
        updateZoomScale()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupImageScrollView()
        updateZoomScale()
    }
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        centerScrollViewContents()
    }
    
    private func setupImageScrollView() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false;
        bouncesZoom = true;
        decelerationRate = .fast;
    }
    
    func centerScrollViewContents() {
        var horizontalInset: CGFloat = 0;
        var verticalInset: CGFloat = 0;
        
        if (contentSize.width < bounds.width) {
            horizontalInset = (bounds.width - contentSize.width) * 0.5;
        }
        
        if (self.contentSize.height < bounds.height) {
            verticalInset = (bounds.height - contentSize.height) * 0.5;
        }
        
        if (window?.screen.scale < 2.0) {
            horizontalInset = floor(horizontalInset);
            verticalInset = floor(verticalInset);
        }
        
        // Use `contentInset` to center the contents in the scroll view. Reasoning explained here: http://petersteinberger.com/blog/2013/how-to-center-uiscrollview/
        self.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset);
    }
    
    private func updateImage(_ image: UIImage?) {
        let size = image?.size ?? CGSize.zero
        
        imageView.transform = CGAffineTransform.identity
        imageView.image = image
        imageView.frame = CGRect(origin: CGPoint.zero, size: size)
        self.contentSize = size
        
        updateZoomScale()
        centerScrollViewContents()
    }
    
    private func updateZoomScale() {
        if let image = imageView.image {
            let scrollViewFrame = self.bounds
            let scaleWidth = scrollViewFrame.size.width / image.size.width
            let scaleHeight = scrollViewFrame.size.height / image.size.height
            let minimumScale = min(scaleWidth, scaleHeight)
            
            minimumZoomScale = minimumScale
            maximumZoomScale = max(minimumScale, maximumZoomScale)
            
            zoomScale = minimumZoomScale
            panGestureRecognizer.isEnabled = false
        }
    }
}
