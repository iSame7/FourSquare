//
//  VenueCollectionViewCell.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 19/05/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit
import Nuke

class VenueCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    struct ViewModel {
        let imageName: String?
        let title: String
        let categoryName: String
        let description: String
    }
    
    func configure(viewModel: ViewModel) {
        if let imagePath = viewModel.imageName, let imageURL = URL(string: imagePath) {
            Nuke.loadImage(with: imageURL, into: image)
        } else {
            image.image = #imageLiteral(resourceName: "restaurant")
        }
        
        titleLabel.text = viewModel.title
        categoryNameLabel.text = viewModel.categoryName
        descriptionLabel.text = viewModel.description
    }
}
