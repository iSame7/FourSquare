//
//  UINavigationBar+Transitions.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 16/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit

extension UINavigationBar {
    private struct AssociatedKeys {
        static var overlayKey = "overlayKey"
    }
    
    var overlay: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.overlayKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.overlayKey, newValue as UIView?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}

extension UINavigationBar {
    func setBackgroundColor(backgroundColor: UIColor) {
        if overlay == nil {
            setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            var navBarHeight: CGFloat = 0
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 2436:
                    // iPhone X
                    navBarHeight = 44
                default:
                    navBarHeight = 20
                }
            }
            overlay = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + navBarHeight))
            overlay?.isUserInteractionEnabled = false
            overlay?.autoresizingMask = UIView.AutoresizingMask.flexibleRightMargin
            if let overlay = overlay {
                subviews.first?.insertSubview(overlay, at: 0)
            }
        }
        overlay?.backgroundColor = backgroundColor
    }
    
    func setTranslationY(translationY: CGFloat) {
        transform = CGAffineTransform(translationX: 0, y: translationY)
    }
    
    func reset() {
        isTranslucent = false
        setBackgroundImage(#imageLiteral(resourceName: "bgGreenyblue"), for: .default)
        
        overlay?.removeFromSuperview()
        overlay = nil
    }
}

extension UINavigationController {
    func setNavigationBarHidden(_ hidden: Bool) {
        navigationBar.setBackgroundColor(backgroundColor: UIColor.navBarColor.withAlphaComponent(hidden ? 0 : 1))
    }
}
