//
//  InAppNotifications.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 16/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit

class InAppNotifications {
    static let success: InAppNotificationType = CRNotificationTypeDefinition(textColor: UIColor.white, backgroundColor: UIColor.flatGreen, image: UIImage(named: "success", in: Bundle(for: InAppNotifications.self), compatibleWith: nil))
    static let error: InAppNotificationType = CRNotificationTypeDefinition(textColor: UIColor.white, backgroundColor: UIColor.flatRed, image: UIImage(named: "error", in: Bundle(for: InAppNotifications.self), compatibleWith: nil))
    static let info: InAppNotificationType = CRNotificationTypeDefinition(textColor: UIColor.white, backgroundColor: UIColor.flatGray, image: UIImage(named: "info", in: Bundle(for: InAppNotifications.self), compatibleWith: nil))
    
    
    // MARK: - Init
    
    public init(){}
    
    
    // MARK: - Helpers
    
    @discardableResult
    static func showNotification(textColor: UIColor, backgroundColor: UIColor, image: UIImage?, title: String, message: String, dismissDelay: TimeInterval, completion: @escaping () -> () = {}) -> InAppNotification? {
        let notificationDefinition = CRNotificationTypeDefinition(textColor: textColor, backgroundColor: backgroundColor, image: image)
        return showNotification(type: notificationDefinition, title: title, message: message, dismissDelay: dismissDelay, completion: completion)
    }
    

    @discardableResult
    static func showNotification(type: InAppNotificationType, title: String, message: String, dismissDelay: TimeInterval, completion: @escaping () -> () = {}) -> InAppNotification? {
        let view = NotificationView()
        
        view.setBackgroundColor(color: type.backgroundColor)
        view.setTextColor(color: type.textColor)
        view.setImage(image: type.image)
        view.setTitle(title: title)
        view.setMessage(message: message)
        view.setDismisTimer(delay: dismissDelay)
        view.setCompletionBlock(completion)
        
        guard let window = UIApplication.shared.keyWindow else {
            print("Failed to show in app notification.")
            return nil
        }
        
        window.addSubview(view)
        view.showNotification()
        
        return view
    }
}

fileprivate struct CRNotificationTypeDefinition: InAppNotificationType {
    var textColor: UIColor
    var backgroundColor: UIColor
    var image: UIImage?
}
