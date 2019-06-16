//
//  DeviceManager.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 16/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit

open class DeviceManager {
    
    private init() {}
    
    static func device() -> Device {
        let size = CGSize(width: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height),
                          height: max(UIScreen.main.bounds.width, UIScreen.main.bounds.height))
        
        switch size {
        case CGSize(width: 320.0, height: 480.0):
            return .iPhone35
        case CGSize(width: 320.0, height: 568.0):
            return .iPhone40
        case CGSize(width: 375.0, height: 667.0):
            return .iPhone47
        case CGSize(width: 375.0, height: 812.0):
            return .iPhone58
        case CGSize(width: 414.0, height: 736.0):
            return .iPhone55
        case CGSize(width: 540.0, height: 960.0):
            return .iPhone55
        case CGSize(width: 621.0, height: 1104.0):
            return .iPhone55
        case CGSize(width: 562.5, height: 1218.0):
            return .iPhone58
        case CGSize(width: 414.0, height: 896.0):
            return .iPhone61
        case CGSize(width: 384.0, height: 512.0):
            return .iPadSmall
        case CGSize(width: 768.0, height: 1024.0):
            return .iPadSmall
        case CGSize(width: 834.0, height: 1112.0):
            return .iPadMedium
        case CGSize(width: 1024.0, height: 1366.0):
            return .iPadBig
        default:
            return .unknown
        }
    }
    
    /// Returns a value based on the current iPhone device.
    static func value<T>(iPhone35: T, iPhone40: T, iPhone47: T, iPhone55: T, iPhone58: T, iPhone61: T) -> T {
        switch device() {
        case .iPhone35:
            return iPhone35
        case .iPhone40:
            return iPhone40
        case .iPhone47:
            return iPhone47
        case .iPhone55:
            return iPhone55
        case .iPhone61:
            return iPhone61
        default:
            return iPhone58
        }
    }
    
    /// Returns a value based on the current iPad device.
    static func value<T>(iPadSmall: T, iPadMedium: T, iPadBig: T) -> T {
        switch device() {
        case .iPadSmall:
            return iPadSmall
        case .iPadMedium:
            return iPadMedium
        default:
            return iPadBig
        }
    }
    
    /// Returns a value based on the current iPhone or iPad device.
    static func value<T>(iPhone35: T, iPhone40: T, iPhone47: T, iPhone55: T, iPhone58: T, iPhone61: T, iPadSmall: T, iPadMedium: T, iPadBig: T) -> T {
        switch device() {
        case .iPhone35:
            return iPhone35
        case .iPhone40:
            return iPhone40
        case .iPhone47:
            return iPhone47
        case .iPhone55:
            return iPhone55
        case .iPhone58:
            return iPhone58
        case .iPhone61:
            return iPhone61
        case .iPadSmall:
            return iPadSmall
        case .iPadMedium:
            return iPadMedium
        case .iPadBig:
            return iPadBig
        default:
            if UIDevice.current.userInterfaceIdiom == .pad {
                return iPadBig
            } else {
                return iPhone55
            }
        }
    }
    
    /// Returns a value based on the current iPhone or iPad device.
    static func value<T>(iPhone: T, iPad: T) -> T {
        return value(iPhone35: iPhone, iPhone40: iPhone, iPhone47: iPhone, iPhone55: iPhone, iPhone58: iPhone, iPhone61: iPhone, iPadSmall: iPad, iPadMedium: iPad, iPadBig: iPad)
    }
    
    static func value<T>(iPhoneX: T, other: T) -> T {
        return value(iPhone35: other, iPhone40: other, iPhone47: other, iPhone55: other, iPhone58: iPhoneX, iPhone61: iPhoneX, iPadSmall: other, iPadMedium: other, iPadBig: other)
    }
    
}

enum Device {
    case iPhone35
    case iPhone40
    case iPhone47
    case iPhone55
    case iPhone58
    case iPhone61
    
    case iPadSmall
    case iPadMedium
    case iPadBig
    
    case unknown
}
