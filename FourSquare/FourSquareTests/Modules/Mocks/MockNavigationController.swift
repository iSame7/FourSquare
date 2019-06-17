//
//  MockNavigationController.swift
//  FourSquareTests
//
//  Created by Sameh Mabrouk on 17/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

@testable import FourSquare

import UIKit

class MockNavigationController: NavigationControlling {
    
    var isPushCalled = false
    var isPoped = false
    var viewControllerPushed: UIViewController?
    var currentViewController: UIViewController?
    
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        isPushCalled = true
        viewControllerPushed = viewController
    }
    
    func popViewController(animated: Bool) -> UIViewController? {
        isPoped = true
        
        currentViewController = MapViewController()
        
        return DetailsViewController()
    }
    
}
