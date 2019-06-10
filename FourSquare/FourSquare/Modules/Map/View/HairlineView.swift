//
//  HairlineView.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 02/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit

// Create a 0.5px Hairline, since storyboard cannot accept 0.5 height for UIViews.
class HairlineView: UIView {
    override func awakeFromNib() {
        backgroundColor = UIColor.clear
    }
    
    public override func draw(_: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(0.5)
        context.setStrokeColor(UIColor(red: 210.0 / 255.0, green: 212.0 / 255.0, blue: 217.0 / 255.0, alpha: 1.0).cgColor)
        context.move(to: CGPoint(x: 0, y: frame.size.height))
        context.addLine(to: CGPoint(x: frame.size.width, y: 0))
        context.strokePath()
    }
}
