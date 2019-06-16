//
//  PhotoCollectionViewVCell.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 09/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit
import Nuke

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    static let ReuseCellID = "GalleryCollectionViewCell"

    struct ViewModel {
        let imageURL: String?
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        imageView.layer.cornerRadius = 8
//        imageView.clipsToBounds = true
    }
    
    func setup(with viewModel: ViewModel) {
        if let imagePath = viewModel.imageURL, let imageURL = URL(string: imagePath) {
            Nuke.loadImage(with: imageURL, options: ImageLoadingOptions(placeholder: #imageLiteral(resourceName: "restaurantPlaceholder"), transition: nil, failureImage: #imageLiteral(resourceName: "restaurant"), failureImageTransition: nil, contentModes: nil), into: imageView, progress: nil, completion: nil)
        } else {
            imageView.image = #imageLiteral(resourceName: "placeholder")
        }
    }
    
    func setup(with photo: PhotoViewable) {
        photo.loadThumbnailImageWithCompletionHandler { [weak photo] (image, error) in
            if let image = image {
                if let photo = photo as? GalleryPhoto {
                    photo.thumbnailImage = image
                }
                self.imageView.image = image
            }
        }
    }
}
