//
//  MapURLHandler.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 09/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import MapKit

protocol MapURLHandling {
    func openMap(location: Location, type: MapType)
}

enum MapType {
    case apple
    case google
}

class MapURLHandler: MapURLHandling {
    func openMap(location: Location, type: MapType) {
        switch type {
        case .apple:
            let coordinate = CLLocationCoordinate2DMake(location.lat, location.lng)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
            mapItem.name = location.address
            mapItem.openInMaps(launchOptions: nil)
        case .google:
            let googleMapsURL = "https://www.google.com/maps"
            guard let encodedTitle = location.address?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string:
                    "\(googleMapsURL)?q=\(encodedTitle)&center=\(String(location.lat)),\(String(location.lng))") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
