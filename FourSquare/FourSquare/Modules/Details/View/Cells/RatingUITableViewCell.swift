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
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var checkInLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    let ratingCircleWidth = CGFloat(100.0)
    let ratingCircleHeight = CGFloat(100.0)
    
    struct ViewModel {
        let rating: Double
        let visitorsCount: Int
        let likesCount: Int
        let checkInsCount: Int
        let tipCount: Int
    }
    
    func setup(with viewModel: ViewModel) {
        let ratingCircleViewWidth = ratingView.frame.width
        let ratingCircleViewHeight = ratingView.frame.height
        let circleView = RatingCircleView(frame: CGRect(x: ratingCircleViewWidth/2 - ratingCircleWidth/2, y: ratingCircleViewHeight/2 - ratingCircleHeight/2, width: ratingCircleWidth, height: ratingCircleHeight), rating: Double(viewModel.rating * 10))
        ratingView.addSubview(circleView)
        circleView.animateCircle(duration: 1.0)
        
        ratingLabel.text = String(viewModel.rating)
        subtitle.text = "Rated \(viewModel.rating) out of 10 based on \(viewModel.visitorsCount > 0 ? String(viewModel.visitorsCount) : "-") visitor"
        likesLabel.text = viewModel.likesCount > 0 && viewModel.visitorsCount > 0 ? String((viewModel.likesCount / viewModel.visitorsCount) * 100) + "% likes" : "- % likes"
        tipsLabel.text = viewModel.tipCount > 0 && viewModel.visitorsCount > 0 ? String((viewModel.tipCount / viewModel.visitorsCount) * 100) + "% tips" : "- % tips"
        checkInLabel.text = viewModel.checkInsCount > 0 ? String((viewModel.checkInsCount / viewModel.visitorsCount) * 100) + "% Check in" : "- % Check in"
    }
}
