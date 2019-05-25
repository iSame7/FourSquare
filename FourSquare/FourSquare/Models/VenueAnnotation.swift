//
//  VenueAnnotation.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 19/05/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import Foundation
import MapKit

class VenueAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let category: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, category: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.category = category
    }
}
