//
//  CRNotificationType.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 16/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit

protocol InAppNotificationType {
    var textColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var image: UIImage? { get }
}
