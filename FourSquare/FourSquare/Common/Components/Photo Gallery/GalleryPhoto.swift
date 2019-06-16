//
//  GalleryPhoto.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 16/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol PhotoViewable: class {
    var image: UIImage? { get }
    var thumbnailImage: UIImage? { get }
    @objc optional var isDeletable: Bool { get }
    
    func loadImageWithCompletionHandler(_ completion: @escaping (_ image: UIImage?, _ error: Error?) -> ())
    func loadThumbnailImageWithCompletionHandler(_ completion: @escaping (_ image: UIImage?, _ error: Error?) -> ())
    
    var attributedTitle: NSAttributedString? { get }
}

class GalleryPhoto: NSObject, PhotoViewable {
    @objc open var image: UIImage?
    @objc open var thumbnailImage: UIImage?
    @objc open var isDeletable: Bool
    
    var imageURL: URL?
    var thumbnailImageURL: URL?
    
    @objc open var attributedTitle: NSAttributedString?
    
    public init(image: UIImage?, thumbnailImage: UIImage?) {
        self.image = image
        self.thumbnailImage = thumbnailImage
        self.isDeletable = false
    }
    
    public init(imageURL: URL?, thumbnailImageURL: URL?) {
        self.imageURL = imageURL
        self.thumbnailImageURL = thumbnailImageURL
        self.isDeletable = false
    }
    
    public init (imageURL: URL?, thumbnailImage: UIImage?) {
        self.imageURL = imageURL
        self.thumbnailImage = thumbnailImage
        self.isDeletable = false
    }
    
    @objc open func loadImageWithCompletionHandler(_ completion: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        if let image = image {
            completion(image, nil)
            return
        }
        loadImageWithURL(imageURL, completion: completion)
    }
    @objc open func loadThumbnailImageWithCompletionHandler(_ completion: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        if let thumbnailImage = thumbnailImage {
            completion(thumbnailImage, nil)
            return
        }
        loadImageWithURL(thumbnailImageURL, completion: completion)
    }
    
    open func loadImageWithURL(_ url: URL?, completion: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        if let imageURL = url {
            session.dataTask(with: imageURL, completionHandler: { (response, data, error) in
                DispatchQueue.main.async(execute: { () -> Void in
                    if error != nil {
                        completion(nil, error)
                    } else if let response = response, let image = UIImage(data: response) {
                        completion(image, nil)
                    } else {
                        completion(nil, NSError(domain: "INSPhotoDomain", code: -1, userInfo: [ NSLocalizedDescriptionKey: "Couldn't load image"]))
                    }
                    session.finishTasksAndInvalidate()
                })
            }).resume()
        } else {
            completion(nil, NSError(domain: "INSPhotoDomain", code: -2, userInfo: [ NSLocalizedDescriptionKey: "Image URL not found."]))
        }
    }
}

func ==<T: GalleryPhoto>(lhs: T, rhs: T) -> Bool {
    return lhs === rhs
}
