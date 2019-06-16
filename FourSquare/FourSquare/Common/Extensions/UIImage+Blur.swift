//
//  UIImage+Blur.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 15/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit

extension UIImage {
    func blur(blurAmount: CGFloat) -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        blurFilter?.setValue(blurAmount, forKey: kCIInputRadiusKey)
        
        guard let outputImage = blurFilter?.outputImage  else { return nil }
        
        return UIImage(ciImage: outputImage)
    }
}
