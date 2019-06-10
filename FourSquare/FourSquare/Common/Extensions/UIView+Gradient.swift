//
//  UIView+Gradient.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 31/05/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit

extension UIView {
    func addGradient(colors: [CGColor]){
        let gradient = CAGradientLayer()
        gradient.frame.size = frame.size
        gradient.colors = colors
        layer.addSublayer(gradient)
    }
}
