//
//  PhotoGalleryTableViewCell.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 09/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit

private let kImgName = "img_"
private let kTotalImgs = 10

class PhotoGalleryTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        collectionView.register(UINib(nibName: "\(PhotoCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "GalleryCollectionViewCell")
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        collectionView.layoutIfNeeded()
        collectionView.frame = CGRect(x: 0, y: 0, width: targetSize.width , height: 1)
        return collectionView.collectionViewLayout.collectionViewContentSize
    }
    
//    func setup(with viewModel: ) -> <#return type#> {
//        <#function body#>
//    }
}

extension PhotoGalleryTableViewCell: UICollectionViewDelegate {
    
}

extension PhotoGalleryTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imgNumber = indexPath.item % kTotalImgs + 1
        let imageName = kImgName + "\(imgNumber)"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.configure()
        
        return cell
    }
}
