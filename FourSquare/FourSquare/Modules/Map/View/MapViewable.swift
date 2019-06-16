//
//  MapViewable.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 01/04/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

protocol MapViewable: class {
    func update(_ model: [Venue])
    func showError(error: FoursquareError) 
    func update(with photo: String, for venueId: String) 
    func updateUserLocation(_ locationViewModel: MapViewController.LocationViewModel) 
}
