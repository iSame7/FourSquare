//
//  VenueHeaderView.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 31/05/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit
import Nuke

typealias BackActionHandler = (() -> Void)

class VenueUITableHeaderView: UIView, NibOwnerLoadable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var backAction: BackActionHandler?
    
    struct ViewModel {
        let title: String
        let description: String
        let imageURL: String?
    }
    
    
    init(frame: CGRect, backAction: @escaping BackActionHandler) {
        super.init(frame: frame)
        
        self.backAction = backAction
        
        loadNibContent()
        setupStyle()

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadNibContent()
        setupStyle()
    }
    
    func setupStyle() {
        shadowView.addGradient(colors: [UIColor.black.withAlphaComponent(0).cgColor, UIColor.black.withAlphaComponent(0.2).cgColor, UIColor.black.withAlphaComponent(0.3).cgColor])
    }
    
    func configure(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        let placeholderImage = UIImage(named: "restraunt-placeholder2")?.blur(blurAmount: 2.5)
        if let imagePath = viewModel.imageURL, let imageURL = URL(string: imagePath) {
            Nuke.loadImage(with: imageURL, options: ImageLoadingOptions(placeholder: placeholderImage, transition: nil, failureImage: placeholderImage, failureImageTransition: nil, contentModes: nil), into: imageView, progress: nil, completion: nil)
        } else {
            imageView.image = placeholderImage
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        backAction?()
    }
}
