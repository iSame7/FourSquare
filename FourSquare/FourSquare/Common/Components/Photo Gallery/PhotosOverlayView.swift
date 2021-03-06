//
//  PhotosOverlayView.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 16/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit

public protocol PhotoOverlayViewable:class {
    var photosViewController: PhotosViewController? { get set }
    
    func populateWithPhoto(_ photo: PhotoViewable)
    func setHidden(_ hidden: Bool, animated: Bool)
    func view() -> UIView
}

extension PhotoOverlayViewable where Self: UIView {
    public func view() -> UIView {
        return self
    }
}

open class PhotosOverlayView: UIView , PhotoOverlayViewable {
    open private(set) var navigationBar: UINavigationBar!
    open private(set) var captionLabel: UILabel!
    open private(set) var deleteToolbar: UIToolbar!
    
    open private(set) var navigationItem: UINavigationItem!
    open weak var photosViewController: PhotosViewController?
    private var currentPhoto: PhotoViewable?
    
    private var topShadow: CAGradientLayer!
    private var bottomShadow: CAGradientLayer!
    
    open var leftBarButtonItem: UIBarButtonItem? {
        didSet {
            navigationItem.leftBarButtonItem = leftBarButtonItem
        }
    }
    open var rightBarButtonItem: UIBarButtonItem? {
        didSet {
            navigationItem.rightBarButtonItem = rightBarButtonItem
        }
    }
    
    #if swift(>=4.0)
    open var titleTextAttributes: [NSAttributedString.Key : AnyObject] = [:] {
        didSet {
            navigationBar.titleTextAttributes = titleTextAttributes
        }
    }
    #else
    open var titleTextAttributes: [String : AnyObject] = [:] {
        didSet {
            navigationBar.titleTextAttributes = titleTextAttributes
        }
    }
    #endif
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadows()
        setupNavigationBar()
        setupCaptionLabel()
        setupDeleteButton()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Pass the touches down to other views
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) , hitView != self {
            return hitView
        }
        return nil
    }
    
    open override func layoutSubviews() {
        // The navigation bar has a different intrinsic content size upon rotation, so we must update to that new size.
        // Do it without animation to more closely match the behavior in `UINavigationController`
        UIView.performWithoutAnimation { () -> Void in
            self.navigationBar.invalidateIntrinsicContentSize()
            self.navigationBar.layoutIfNeeded()
        }
        super.layoutSubviews()
        self.updateShadowFrames()
    }
    
    open func setHidden(_ hidden: Bool, animated: Bool) {
        if self.isHidden == hidden {
            return
        }
        
        if animated {
            self.isHidden = false
            self.alpha = hidden ? 1.0 : 0.0
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: { () -> Void in
                self.alpha = hidden ? 0.0 : 1.0
            }, completion: { result in
                self.alpha = 1.0
                self.isHidden = hidden
            })
        } else {
            self.isHidden = hidden
        }
    }
    
    open func populateWithPhoto(_ photo: PhotoViewable) {
        self.currentPhoto = photo
        
        if let photosViewController = photosViewController {
            if let index = photosViewController.dataSource.indexOfPhoto(photo) {
                navigationItem.title = String(format:NSLocalizedString("%d of %d",comment:""), index+1, photosViewController.dataSource.numberOfPhotos)
            }
            captionLabel.attributedText = photo.attributedTitle
        }
        self.deleteToolbar.isHidden = photo.isDeletable != true
    }
    
    @objc private func closeButtonTapped(_ sender: UIBarButtonItem) {
        photosViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func actionButtonTapped(_ sender: UIBarButtonItem) {
        if let currentPhoto = currentPhoto {
            currentPhoto.loadImageWithCompletionHandler({ [weak self] (image, error) -> () in
                if let image = (image ?? currentPhoto.thumbnailImage) {
                    let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                    activityController.popoverPresentationController?.barButtonItem = sender
                    self?.photosViewController?.present(activityController, animated: true, completion: nil)
                }
            });
        }
    }
    
    @objc private func deleteButtonTapped(_ sender: UIBarButtonItem) {
        photosViewController?.handleDeleteButtonTapped()
    }
    
    private func setupNavigationBar() {
        navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.backgroundColor = UIColor.clear
        navigationBar.barTintColor = nil
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationItem = UINavigationItem(title: "")
        navigationBar.items = [navigationItem]
        addSubview(navigationBar)
        
        let topConstraint: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            topConstraint = NSLayoutConstraint(item: navigationBar!, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0.0)
        } else {
            topConstraint = NSLayoutConstraint(item: navigationBar!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        }
        let widthConstraint = NSLayoutConstraint(item: navigationBar!, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0.0)
        let horizontalPositionConstraint = NSLayoutConstraint(item: navigationBar!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        self.addConstraints([topConstraint,widthConstraint,horizontalPositionConstraint])
        
        if let leftBarButtonImage = UIImage(named: "PhotoGalleryClose"), let leftBarButtonImageLandscape = UIImage(named: "PhotoGalleryCloseLandscape") {
            leftBarButtonItem = UIBarButtonItem(image: leftBarButtonImage, landscapeImagePhone: leftBarButtonImageLandscape, style: .plain, target: self, action: #selector(PhotosOverlayView.closeButtonTapped(_:)))
        } else {
            leftBarButtonItem = UIBarButtonItem(title: "CLOSE".uppercased(), style: .plain, target: self, action: #selector(PhotosOverlayView.closeButtonTapped(_:)))
        }
        
        rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(PhotosOverlayView.actionButtonTapped(_:)))
    }
    
    
    
    private func setupCaptionLabel() {
        captionLabel = UILabel()
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.backgroundColor = UIColor.clear
        captionLabel.numberOfLines = 0
        addSubview(captionLabel)
        
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: captionLabel, attribute: .bottom, multiplier: 1.0, constant: 8.0)
        let leadingConstraint = NSLayoutConstraint(item: captionLabel!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 8.0)
        let trailingConstraint = NSLayoutConstraint(item: captionLabel!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 8.0)
        self.addConstraints([bottomConstraint,leadingConstraint,trailingConstraint])
    }
    
    private func setupShadows() {
        let startColor = UIColor.black.withAlphaComponent(0.5)
        let endColor = UIColor.clear
        
        topShadow = CAGradientLayer()
        topShadow.colors = [startColor.cgColor, endColor.cgColor]
        layer.insertSublayer(topShadow, at: 0)
        
        bottomShadow = CAGradientLayer()
        bottomShadow.colors = [endColor.cgColor, startColor.cgColor]
        layer.insertSublayer(bottomShadow, at: 0)
        
        updateShadowFrames()
    }
    
    private func updateShadowFrames(){
        topShadow.frame = CGRect(x: 0, y: 0, width: frame.width, height: 60)
        bottomShadow.frame = CGRect(x: 0, y: frame.height - 60, width: frame.width, height: 60)
        
    }
    
    private func setupDeleteButton() {
        deleteToolbar = UIToolbar()
        deleteToolbar.translatesAutoresizingMaskIntoConstraints = false
        deleteToolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        deleteToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        deleteToolbar.isTranslucent = true
        let item = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(PhotosOverlayView.deleteButtonTapped(_:)))
        deleteToolbar.setItems([item], animated: false)
        addSubview(deleteToolbar)
        
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: deleteToolbar, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: deleteToolbar, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        
        let widthConstraint = NSLayoutConstraint(item: deleteToolbar!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 65)
        let heightConstraint = NSLayoutConstraint(item: deleteToolbar!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
        addConstraints([bottomConstraint,trailingConstraint,widthConstraint, heightConstraint])
    }
}
