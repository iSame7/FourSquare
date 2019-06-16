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

typealias ImageSelectionHandler = ((_ galleryPreview: PhotosViewController) -> Void)
class PhotoGalleryTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    private var viewModel: ViewModel?
    var selectedImageClosure: ImageSelectionHandler?
    var photos: [PhotoViewable]?
    
    struct ViewModel {
        let photos: [Photo]
    }
    
    override func awakeFromNib() {
        collectionView.register(UINib(nibName: "\(PhotoCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "GalleryCollectionViewCell")
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        if let viewModel = viewModel, !viewModel.photos.isEmpty {
            collectionView.layoutIfNeeded()
            collectionView.frame = CGRect(x: 0, y: 0, width: targetSize.width , height: 1)
            return collectionView.collectionViewLayout.collectionViewContentSize
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func setup(with viewModel: ViewModel, imageSelectionHandler: @escaping ImageSelectionHandler) {
        self.viewModel = viewModel
        selectedImageClosure = imageSelectionHandler
        var photos = [GalleryPhoto]()
        for photo in viewModel.photos {
            photos.append(GalleryPhoto(imageURL: URL(string: "\(photo.prefix)500x500\(photo.suffix)"), thumbnailImageURL: URL(string: "\(photo.prefix)500x500\(photo.suffix)")))
        }
        
        self.photos = photos
        collectionView.reloadData()
    }
}

extension PhotoGalleryTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let photos = photos, let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell {
            let currentPhoto = photos[indexPath.item]
            let galleryPreview = PhotosViewController(photos: photos, initialPhoto: currentPhoto, referenceView: cell)
            
            galleryPreview.referenceViewForPhotoWhenDismissingHandler = { photo in
                if let index = photos.firstIndex(where: {$0 === photo}) {
                    let indexPath = IndexPath(item: index, section: 0)
                    return collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell
                }
                return nil
            }
            selectedImageClosure?(galleryPreview)

        }
    }
}

extension PhotoGalleryTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
//        if let viewModel = viewModel {
//            let imageURL = "\(viewModel.photos[indexPath.item].prefix)500x500\(viewModel.photos[indexPath.item].suffix)"
//                cell.setup(with: PhotoCollectionViewCell.ViewModel(imageURL: imageURL))
//        }
        if let photos = photos {
            cell.setup(with: photos[indexPath.item])
        }
        return cell
    }
}
