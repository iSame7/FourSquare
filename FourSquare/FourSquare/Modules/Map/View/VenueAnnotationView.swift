//
//  VenueAnnotationView.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 19/05/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import MapKit

class VenueLocationView: MKAnnotationView {
    // Required for MKAnnotationView
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
}
