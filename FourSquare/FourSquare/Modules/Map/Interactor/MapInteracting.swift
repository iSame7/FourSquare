//
//  MapInteracting.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 26/03/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

typealias UserLocationBlock = (Location) -> Void
protocol MapInteracting {
    func getRestaurantsAround(coordinate: String, completion: @escaping ([Venue]) -> Void)
    func getVenuePhotos(venueId: String, completion: @escaping ([Photo]) -> Void)
    func determineUserLocation(completion: @escaping UserLocationBlock)
}
