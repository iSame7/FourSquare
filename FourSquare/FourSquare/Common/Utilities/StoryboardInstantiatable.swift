//
//  StoryboardInstantiable.swift
//  DaVinciKit
//
//  Created by Sameh Mabrouk on 24/04/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//
import Foundation
import UIKit

public protocol StoryboardInstantiatable {
    static var storyboardName: String { get }
    static var storyboardBundle: Bundle { get }
    static var instantiateType: StoryboardInstantiateType { get }
}

public extension StoryboardInstantiatable  where Self : NSObject {
    static var storyboardName: String {
        return className
    }
    
    static var storyboardBundle: Bundle {
        return Bundle(for: self)
    }
    
    private static var storyboard: UIStoryboard {
        return UIStoryboard(name: storyboardName, bundle: storyboardBundle)
    }
    
    static var instantiateType: StoryboardInstantiateType {
        return StoryboardInstantiateType.identifier(className)
    }
}

public extension StoryboardInstantiatable where Self: UIViewController {
    static func instantiate() -> Self {
        switch instantiateType {
        case .initial:
            return storyboard.instantiateInitialViewController() as! Self
        case .identifier(let identifier):
            return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
        }
    }
}
