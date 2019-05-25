//
//  MapInteractor.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 26/03/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

class MapInteractor: MapInteracting {
    weak var presenter: MapPresenting?
    private let locationService: LocationServiceChecking
    private let venueService: VenueFetching
    
    init(locationService: LocationServiceChecking, venueService: VenueFetching) {
        self.locationService = locationService
        self.venueService = venueService
    }
    
    func getRestaurantsAround(coordinate: String, completion: @escaping ([Venue]) -> Void) {
        venueService.fetchVenues(coordinate: coordinate) { venues in
            completion(venues)
        }
    }
    
    func determineUserLocation(completion: @escaping UserLocationBlock) {
        locationService.retuestAuthorization()
        locationService.requestUserLocation { location in
            completion(location)
        }
    }
    
    func getVenuePhotos(venueId: String, completion: @escaping ([Photo]) -> Void) {
        venueService.fetchVenuePhotos(venueId: venueId) { photos in
            completion(photos)
        }
    }
}
