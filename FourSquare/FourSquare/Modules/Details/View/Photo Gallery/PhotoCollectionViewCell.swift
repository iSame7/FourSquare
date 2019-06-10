//
//  PhotoCollectionViewVCell.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 09/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    static let ReuseCellID = "GalleryCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
//        imageView.layer.cornerRadius = 8
//        imageView.clipsToBounds = true
    }
    
    func configure() {
        imageView.image = #imageLiteral(resourceName: "placeholder")
    }
}
