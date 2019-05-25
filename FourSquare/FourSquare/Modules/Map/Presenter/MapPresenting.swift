//
//  MapPresenting.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 26/03/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

protocol MapPresenting: class {
    func viewDidLoad()
    func getRestaurantsAround(coordinate: String)
    func getPhotos(venueId: String)
}
