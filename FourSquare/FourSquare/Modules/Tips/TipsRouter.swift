//
//  TipsRouter.swift
//  FourSquare
//
//  Created Sameh Mabrouk on 10/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//
//  Template generated by Sameh Mabrouk https://github.com/iSame7
//

import Foundation
import Swinject

class TipsRouter: TipsRouting {
    
    weak var viewController: Presentable?
    
    func navigateToDetailsModule(viewController: Presentable?) {
        viewController?.dismiss(animated: true, completion: nil)
    }
}