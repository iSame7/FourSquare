//
//  MapPresenter.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 26/03/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import UIKit

class MapPresenter: MapPresenting {
    private weak var view: MapViewable?
    private let mapInteractor: MapInteracting
    private let router: MapRoutting
    
    init(view: MapViewable?, mapInteractor: MapInteracting, router: MapRoutting) {
        self.view = view
        self.mapInteractor = mapInteractor
        self.router = router
    }
    
    func viewDidLoad() {
        mapInteractor.determineUserLocation { [weak self] location in
            self?.view?.updateUserLocation(MapViewController.LocationViewModel(lat: location.lat, lng: location.lng))
        }
    }
    
    func getRestaurantsAround(coordinate: String) {
        mapInteractor.getRestaurantsAround(coordinate: coordinate) { [weak self] (venues, error) in
            if let venues = venues {
                self?.view?.update(venues)
            } else if let error = error {
                self?.view?.showError(error: error)
            }
        }
    }
    
    func getPhotos(venueId: String) {
        mapInteractor.getVenuePhotos(venueId: venueId) { [weak self] photos in
            print("Photos: \(photos)")
            if !photos.isEmpty {
                let photo = "\(photos[0].prefix)700x500\(photos[0].suffix)"
                self?.view?.update(with: photo, for: venueId)
            }

        }
    }
    
    func showDetailsViewController(venue: Venue, venuePhotoURL: String?) {
        guard let vmapViewController = view as? UIViewController else { return }
        
        router.navigateToDetailsModule(navController: vmapViewController.navigationController, venue: venue, venuePhotoURL: venuePhotoURL)
    }
}

