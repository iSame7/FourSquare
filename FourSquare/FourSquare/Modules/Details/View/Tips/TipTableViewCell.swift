//
//  TipTableViewCell.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 10/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit
import Nuke

class TipTableViewCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    struct ViewModel {
        let userName: String
        let userImageURL: String?
        let createdAt: String
        let tipText: String
    }
    
    func setup(with viewModel: ViewModel) {
        if let imagePath = viewModel.userImageURL, let imageURL = URL(string: imagePath) {
            Nuke.loadImage(with: imageURL, options: ImageLoadingOptions(placeholder: #imageLiteral(resourceName: "user"), transition: nil, failureImage: #imageLiteral(resourceName: "user"), failureImageTransition: nil, contentModes: nil), into: userImageView, progress: nil, completion: nil)
        } else {
            userImageView.image = #imageLiteral(resourceName: "user")
        }
        
        userNameLabel.text = viewModel.userName
        createdAtLabel.text = viewModel.createdAt
        tipLabel.text = viewModel.tipText
    }
}
