//
//  INSPhotosViewController.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 16/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit

public typealias INSPhotosViewControllerReferenceViewHandler = (_ photo: PhotoViewable) -> (UIView?)
public typealias INSPhotosViewControllerNavigateToPhotoHandler = (_ photo: PhotoViewable) -> ()
public typealias INSPhotosViewControllerDismissHandler = (_ viewController: PhotosViewController) -> ()
public typealias INSPhotosViewControllerLongPressHandler = (_ photo: PhotoViewable, _ gestureRecognizer: UILongPressGestureRecognizer) -> (Bool)
public typealias INSPhotosViewControllerDeletePhotoHandler = (_ photo: PhotoViewable) -> ()


open class PhotosViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIViewControllerTransitioningDelegate {
    
    /*
     * Returns the view from which to animate for object conforming to INSPhotoViewable
     */
    open var referenceViewForPhotoWhenDismissingHandler: INSPhotosViewControllerReferenceViewHandler?
    
    /*
     * Called when a new photo is displayed through a swipe gesture.
     */
    open var navigateToPhotoHandler: INSPhotosViewControllerNavigateToPhotoHandler?
    
    /*
     * Called before INSPhotosViewController will start a user-initiated dismissal.
     */
    open var willDismissHandler: INSPhotosViewControllerDismissHandler?
    
    /*
     * Called after the INSPhotosViewController has been dismissed by the user.
     */
    open var didDismissHandler: INSPhotosViewControllerDismissHandler?
    
    /*
     * Called when a photo is long pressed.
     */
    open var longPressGestureHandler: INSPhotosViewControllerLongPressHandler?
    
    /*
     * Called when delete is tapped on a photo
     */
    open var deletePhotoHandler: INSPhotosViewControllerDeletePhotoHandler?
    
    /*
     * The overlay view displayed over photos, can be changed but must implement INSPhotosOverlayViewable
     */
    open var overlayView: PhotoOverlayViewable = PhotosOverlayView(frame: CGRect.zero) {
        willSet {
            overlayView.view().removeFromSuperview()
        }
        didSet {
            overlayView.photosViewController = self
            overlayView.view().autoresizingMask = [.flexibleWidth, .flexibleHeight]
            overlayView.view().frame = view.bounds
            view.addSubview(overlayView.view())
        }
    }
    
    /*
     * Whether or not we should confirm with the user before deleting a photo
     */
    open var shouldConfirmDeletion: Bool = false
    
    /*
     * INSPhotoViewController is currently displayed by page view controller
     */
    open var currentPhotoViewController: PhotoViewController? {
        return pageViewController.viewControllers?.first as? PhotoViewController
    }
    
    /*
     * Photo object that is currently displayed by INSPhotoViewController
     */
    open var currentPhoto: PhotoViewable? {
        return currentPhotoViewController?.photo
    }
    
    /*
     * maximum zoom scale for the photos. Default is 1.0
     */
    open var maximumZoomScale: CGFloat = 1.0 {
        didSet {
            currentPhotoViewController?.scalingImageView.maximumZoomScale = maximumZoomScale
        }
    }
    
    // MARK: - Private
    private(set) var pageViewController: UIPageViewController!
    private(set) var dataSource: PhotoDataSource
    
    public let interactiveAnimator: PhotoInteractionAnimator = PhotoInteractionAnimator()
    public let transitionAnimator: PhotoTransitionAnimator = PhotoTransitionAnimator()
    
    public private(set) lazy var singleTapGestureRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(PhotosViewController.handleSingleTapGestureRecognizer(_:)))
    }()
    public private(set) lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(PhotosViewController.handlePanGestureRecognizer(_:)))
    }()
    
    private var interactiveDismissal: Bool = false
    private var statusBarHidden = false
    private var shouldHandleLongPressGesture = false
    
    private func newCurrentPhotoAfterDeletion(currentPhotoIndex: Int) -> PhotoViewable? {
        let previousPhotoIndex = currentPhotoIndex - 1
        if let newCurrentPhoto = self.dataSource.photoAtIndex(currentPhotoIndex) {
            return newCurrentPhoto
        }else if let previousPhoto = self.dataSource.photoAtIndex(previousPhotoIndex) {
            return previousPhoto
        }
        return nil
    }
    
    private func orientationMaskSupportsOrientation(mask: UIInterfaceOrientationMask, orientation: UIInterfaceOrientation) -> Bool {
        return (mask.rawValue & (1 << orientation.rawValue)) != 0
    }
    
    // MARK: - Initialization
    
    deinit {
        pageViewController.delegate = nil
        pageViewController.dataSource = nil
    }
    
    required public init?(coder aDecoder: NSCoder) {
        dataSource = PhotoDataSource(photos: [])
        super.init(nibName: nil, bundle: nil)
        initialSetupWithInitialPhoto(nil)
    }
    
    public override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        dataSource = PhotoDataSource(photos: [])
        super.init(nibName: nil, bundle: nil)
        initialSetupWithInitialPhoto(nil)
    }
    
    /**
     The designated initializer that stores the array of objects implementing INSPhotoViewable
     
     - parameter photos:        An array of objects implementing INSPhotoViewable.
     - parameter initialPhoto:  The photo to display initially. Must be contained within the `photos` array.
     - parameter referenceView: The view from which to animate.
     
     - returns: A fully initialized object.
     */
    public init(photos: [PhotoViewable], initialPhoto: PhotoViewable? = nil, referenceView: UIView? = nil) {
        dataSource = PhotoDataSource(photos: photos)
        super.init(nibName: nil, bundle: nil)
        initialSetupWithInitialPhoto(initialPhoto)
        transitionAnimator.startingView = referenceView
        transitionAnimator.endingView = currentPhotoViewController?.scalingImageView.imageView
    }
    
    private func initialSetupWithInitialPhoto(_ initialPhoto: PhotoViewable? = nil) {
        overlayView.photosViewController = self
        setupPageViewControllerWithInitialPhoto(initialPhoto)
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
        modalPresentationCapturesStatusBarAppearance = true
        
        setupOverlayViewInitialItems()
    }
    
    private func setupOverlayViewInitialItems() {
        let textColor = view.tintColor ?? UIColor.white
        if let overlayView = overlayView as? PhotosOverlayView {
            overlayView.photosViewController = self
            #if swift(>=4.0)
            overlayView.titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]
            #else
            overlayView.titleTextAttributes = [NSForegroundColorAttributeName: textColor]
            #endif
        }
    }
    
    // MARK: - View Life Cycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = UIColor.white
        view.backgroundColor = UIColor.black
        pageViewController.view.backgroundColor = UIColor.clear
        
        pageViewController.view.addGestureRecognizer(panGestureRecognizer)
        pageViewController.view.addGestureRecognizer(singleTapGestureRecognizer)
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pageViewController.didMove(toParent: self)
        
        setupOverlayView()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // This fix issue that navigationBar animate to up
        // when presentingViewController is UINavigationViewController
        statusBarHidden = true
        UIView.animate(withDuration: 0.25) { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
        }
        updateCurrentPhotosInformation()
    }
    
    private func setupOverlayView() {
        
        overlayView.view().autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlayView.view().frame = view.bounds
        view.addSubview(overlayView.view())
        overlayView.setHidden(true, animated: false)
    }
    
    private func setupPageViewControllerWithInitialPhoto(_ initialPhoto: PhotoViewable? = nil) {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.interPageSpacing: 16.0])
        pageViewController.view.backgroundColor = UIColor.clear
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        if let photo = initialPhoto , dataSource.containsPhoto(photo) {
            changeToPhoto(photo, animated: false)
        } else if let photo = dataSource.photos.first {
            changeToPhoto(photo, animated: false)
        }
    }
    
    private func updateCurrentPhotosInformation() {
        if let currentPhoto = currentPhoto {
            overlayView.populateWithPhoto(currentPhoto)
        }
    }
    
    // MARK: - Helper methods
    
    private func deleteCurrentPhoto() {
        guard let currentPhoto = self.currentPhoto else {
            return
        }
        guard let currentPhotoIndex = self.dataSource.indexOfPhoto(currentPhoto) else {
            return
        }
        dataSource.deletePhoto(currentPhoto)
        deletePhotoHandler?(currentPhoto)
        if let photo = newCurrentPhotoAfterDeletion(currentPhotoIndex: currentPhotoIndex) {
            if currentPhotoIndex == self.dataSource.numberOfPhotos {
                changeToPhoto(photo, animated: true, direction: .reverse)
            } else{
                changeToPhoto(photo, animated: true)
            }
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func confirmPhotoDeletion(delete: @escaping () -> Void) {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to delete this photo?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Delete Photo", style: .destructive, handler: { (_) in
            delete()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    // MARK: - Public
    
    /**
     Displays the specified photo. Can be called before the view controller is displayed. Calling with a photo not contained within the data source has no effect.
     
     - parameter photo:    The photo to make the currently displayed photo.
     - parameter animated: Whether to animate the transition to the new photo.
     */
    open func changeToPhoto(_ photo: PhotoViewable, animated: Bool, direction: UIPageViewController.NavigationDirection = .forward) {
        if !dataSource.containsPhoto(photo) {
            return
        }
        let photoViewController = initializePhotoViewControllerForPhoto(photo)
        pageViewController.setViewControllers([photoViewController], direction: direction, animated: animated, completion: nil)
        updateCurrentPhotosInformation()
    }
    
    // MARK: - Gesture Recognizers
    
    @objc private func handlePanGestureRecognizer(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        // if current orientation is different from supported orientations of presenting vc, disable flick-to-dismiss
        if let presentingViewController = presentingViewController {
            if !orientationMaskSupportsOrientation(mask: presentingViewController.supportedInterfaceOrientations, orientation: UIApplication.shared.statusBarOrientation) {
                return
            }
        }
        
        if gestureRecognizer.state == .began {
            interactiveDismissal = true
            dismiss(animated: true, completion: nil)
        } else {
            interactiveDismissal = false
            interactiveAnimator.handlePanWithPanGestureRecognizer(gestureRecognizer, viewToPan: pageViewController.view, anchorPoint: CGPoint(x: view.bounds.midX, y: view.bounds.midY))
        }
    }
    
    @objc private func handleSingleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        overlayView.setHidden(!overlayView.view().isHidden, animated: true)
    }
    
    // MARK: - Target Actions
    
    open func handleDeleteButtonTapped(){
        if shouldConfirmDeletion {
            confirmPhotoDeletion { [weak self] in
                self?.deleteCurrentPhoto()
            }
        } else {
            deleteCurrentPhoto()
        }
    }
    
    // MARK: - View Controller Dismissal
    
    open override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        if presentedViewController != nil {
            super.dismiss(animated: flag, completion: completion)
            return
        }
        var startingView: UIView?
        if currentPhotoViewController?.scalingImageView.imageView.image != nil {
            startingView = currentPhotoViewController?.scalingImageView.imageView
        }
        transitionAnimator.startingView = startingView
        
        if let currentPhoto = currentPhoto {
            transitionAnimator.endingView = referenceViewForPhotoWhenDismissingHandler?(currentPhoto)
        } else {
            transitionAnimator.endingView = nil
        }
        let overlayWasHiddenBeforeTransition = overlayView.view().isHidden
        overlayView.setHidden(true, animated: true)
        
        willDismissHandler?(self)
        
        super.dismiss(animated: flag) { () -> Void in
            let isStillOnscreen = self.view.window != nil
            if isStillOnscreen && !overlayWasHiddenBeforeTransition {
                self.overlayView.setHidden(false, animated: true)
            }
            
            if !isStillOnscreen {
                self.didDismissHandler?(self)
            }
            completion?()
        }
    }
    
    // MARK: - UIPageViewControllerDataSource / UIPageViewControllerDelegate
    
    public func initializePhotoViewControllerForPhoto(_ photo: PhotoViewable) -> PhotoViewController {
        let photoViewController = PhotoViewController(photo: photo)
        singleTapGestureRecognizer.require(toFail: photoViewController.doubleTapGestureRecognizer)
        photoViewController.longPressGestureHandler = { [weak self] gesture in
            guard let `self` = self else { return }

            self.shouldHandleLongPressGesture = false
            
            if let gestureHandler = self.longPressGestureHandler {
                self.shouldHandleLongPressGesture = gestureHandler(photo, gesture)
            }
            self.shouldHandleLongPressGesture = !self.shouldHandleLongPressGesture
            
            if self.shouldHandleLongPressGesture {
                guard let view = gesture.view else {
                    return
                }
                let menuController = UIMenuController.shared
                var targetRect = CGRect.zero
                targetRect.origin = gesture.location(in: view)
                menuController.setTargetRect(targetRect, in: view)
                menuController.setMenuVisible(true, animated: true)
            }
        }
        photoViewController.scalingImageView.maximumZoomScale = maximumZoomScale
        return photoViewController
    }
    
    @objc open func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let photoViewController = viewController as? PhotoViewController,
            let photoIndex = dataSource.indexOfPhoto(photoViewController.photo),
            let newPhoto = dataSource[photoIndex-1] else {
                return nil
        }
        return initializePhotoViewControllerForPhoto(newPhoto)
    }
    
    @objc open func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let photoViewController = viewController as? PhotoViewController,
            let photoIndex = dataSource.indexOfPhoto(photoViewController.photo),
            let newPhoto = dataSource[photoIndex+1] else {
                return nil
        }
        return initializePhotoViewControllerForPhoto(newPhoto)
    }
    
    @objc open func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            updateCurrentPhotosInformation()
            if let currentPhotoViewController = currentPhotoViewController {
                navigateToPhotoHandler?(currentPhotoViewController.photo)
            }
        }
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator.dismissing = false
        return transitionAnimator
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator.dismissing = true
        return transitionAnimator
    }
    
    open func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if interactiveDismissal {
            transitionAnimator.endingViewForAnimation = transitionAnimator.endingView?.ins_snapshotView()
            interactiveAnimator.animator = transitionAnimator
            interactiveAnimator.shouldAnimateUsingAnimator = transitionAnimator.endingView != nil
            interactiveAnimator.viewToHideWhenBeginningTransition = transitionAnimator.startingView != nil ? transitionAnimator.endingView : nil
            
            return interactiveAnimator
        }
        return nil
    }
    
    // MARK: - UIResponder
    
    open override func copy(_ sender: Any?) {
        UIPasteboard.general.image = currentPhoto?.image ?? currentPhotoViewController?.scalingImageView.image
    }
    
    open override var canBecomeFirstResponder: Bool {
        return true
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if let _ = currentPhoto?.image ?? currentPhotoViewController?.scalingImageView.image , shouldHandleLongPressGesture && action == #selector(NSObject.copy) {
            return true
        }
        return false
    }
    
    // MARK: - Status Bar
    
    open override var prefersStatusBarHidden: Bool {
        if let parentStatusBarHidden = presentingViewController?.prefersStatusBarHidden , parentStatusBarHidden == true {
            return parentStatusBarHidden
        }
        return statusBarHidden
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
}

