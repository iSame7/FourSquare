//
//  MapPresenter.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 26/03/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

class MapPresenter: MapPresenting {
    private weak var view: MapViewable?
    private let mapInteractor: MapInteracting
    
    init(view: MapViewable?, mapInteractor: MapInteracting) {
        self.view = view
        self.mapInteractor = mapInteractor
    }
    
    func viewDidLoad() {
        mapInteractor.determineUserLocation { [weak self] location in
            self?.view?.updateUserLocation(MapViewController.LocationViewModel(lat: location.lat, lng: location.lng))
        }
    }
    
    func getRestaurantsAround(coordinate: String) {
        mapInteractor.getRestaurantsAround(coordinate: coordinate) { [weak self] venues in
//            print("Venues: \(venues)")
            self?.view?.update(venues)
        }
    }
    
    func getPhotos(venueId: String) {
        mapInteractor.getVenuePhotos(venueId: venueId) { [weak self] photos in
            print("Photos: \(photos)")
            let photo = "\(photos[0].prefix)500x500\(photos[0].suffix)"
            self?.view?.update(with: photo, for: venueId)
        }
    }
}

