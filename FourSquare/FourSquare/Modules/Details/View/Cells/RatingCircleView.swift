//
//  RatingCircleView.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 02/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit

class RatingCircleView: UIView {
    var circleLayer: CAShapeLayer!
    
    init(frame: CGRect, rating: Double) {
        super.init(frame: frame)
        
        let ratingAngel = convertRatingToAngle(rating: rating)
        let ratingRadians = convertAngleToRadians(angle: ratingAngel)
        let startAngle = convertAngleToRadians(angle: 0)
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: startAngle, endAngle: ratingRadians, clockwise: true)
        
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.orange.cgColor
        circleLayer.lineWidth = 5.0;
        circleLayer.strokeEnd = 0.0
        
        layer.addSublayer(circleLayer)
        backgroundColor = .clear
    }
    
    func convertRatingToAngle(rating: Double) -> Double {
        return (rating * 360) / 100
    }

    func convertAngleToRadians(angle: Double) -> CGFloat {
        return CGFloat(angle.degreesToRadians + Double.pi / 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateCircle(duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")

        animation.duration = duration
        
        animation.fromValue = 0
        animation.toValue = 1
        
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

        circleLayer.strokeEnd = 1.0
        
        circleLayer.add(animation, forKey: "animateCircle")
    }
}
