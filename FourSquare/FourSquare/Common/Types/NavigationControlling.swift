//
//  NavigationControlling.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 26/05/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit

protocol NavigationControlling: class {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func popViewController(animated: Bool) -> UIViewController? 
}
