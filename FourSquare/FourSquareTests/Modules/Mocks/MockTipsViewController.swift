//
//  MockTipsViewController.swift
//  FourSquareTests
//
//  Created by Sameh Mabrouk on 18/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

@testable import FourSquare

import UIKit

class MockTipsViewController: TipsViewable, Presentable {
    var presenter: TipsPresenting?
    var isPresented = false
    var isDismissed = false
    var viewControllerPresented: UIViewController?
    
    func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        isDismissed = true
    }
    
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        isPresented = true
        viewControllerPresented = viewControllerToPresent
    }
}
