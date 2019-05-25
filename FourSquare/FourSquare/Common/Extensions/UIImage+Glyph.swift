//
//  UIImage+Glyph.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 19/05/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit

enum ImageType: String {
    case restaurant = "4bf58dd8d48988d1c4941735"
    case bakery = "4bf58dd8d48988d16a941735"
    case halal = "52e81612bcbc57f1066b79ff"
    case cafe = "4bf58dd8d48988d16d941735"
    case coffeeShop = "4bf58dd8d48988d1e0931735"
    case asian = "4bf58dd8d48988d145941735"
    case fish = "4edd64a0c7ddd24ca188df1a"
    case doughnut = "4bf58dd8d48988d148941735"
    case food = "4d4b7105d754a06374d81259"
}
extension UIImage {
    static func glyphFor(imageType: ImageType) -> UIImage? {
        switch imageType {
        case .restaurant:
            return #imageLiteral(resourceName: "restaurant")
        case .bakery:
            return #imageLiteral(resourceName: "Bakery")
        case .halal:
            return #imageLiteral(resourceName: "halal")
        case .cafe, .coffeeShop:
            return #imageLiteral(resourceName: "cafe")
        case .asian:
            return #imageLiteral(resourceName: "asian")
        case .fish:
            return #imageLiteral(resourceName: "fish")
        case .doughnut:
            return #imageLiteral(resourceName: "doughnut")
        default:
            return #imageLiteral(resourceName: "restaurant")
        }
    }
}
