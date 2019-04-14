//
//  MapViewController.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 26/03/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    var presenter: MapPresenting?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LocationService.shared.checkForLocationServices()
    }
}

extension MapViewController: MapView {
    func update(_ model: [Venue]) {
    }
}
