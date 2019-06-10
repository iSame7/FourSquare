//
//  RatingUITableViewCell.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 02/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit

class RatingUITableViewCell: UITableViewCell {
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var title: UILabel!
    let ratingCircleWidth = CGFloat(100.0)
    let ratingCircleHeight = CGFloat(100.0)
    
    struct ViewModel {
        let rating: Int
        let visitorsCount: Int
        let likesCount: Int
        let checkInsCount: Int
        let tipCount: Int
    }
    
    func setup() {
        let ratingCircleViewWidth = ratingView.frame.width
        let ratingCircleViewHeight = ratingView.frame.height
        let circleView = RatingCircleView(frame: CGRect(x: ratingCircleViewWidth/2 - ratingCircleWidth/2, y: ratingCircleViewHeight/2 - ratingCircleHeight/2, width: ratingCircleWidth, height: ratingCircleHeight), rating: 85)
        ratingView.addSubview(circleView)
        circleView.animateCircle(duration: 1.0)
    }
}
