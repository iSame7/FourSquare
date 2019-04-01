//
//  LocationService.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 26/03/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import MapKit

class LocationService: NSObject {
    private override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    static let shared = LocationService()
    private var locationManager: CLLocationManager!
}

extension LocationService {
    public func checkForLocationServices() -> CLAuthorizationStatus {
        var status: CLAuthorizationStatus!
        
        if CLLocationManager.locationServicesEnabled() {
            print("location services available")
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                status = CLAuthorizationStatus.notDetermined
            case .denied:
                status = CLAuthorizationStatus.denied
                //opens phone Settings so user can authorize permission
                guard let validSettingsURL: URL = URL(string: UIApplication.openSettingsURLString) else {return status}
                UIApplication.shared.open(validSettingsURL, options: [:], completionHandler: nil)
            case .authorizedWhenInUse:
                status = CLAuthorizationStatus.authorizedWhenInUse
            case .authorizedAlways:
                status = CLAuthorizationStatus.authorizedAlways
            case .restricted:
                status = CLAuthorizationStatus.restricted
                guard let validSettingsURL: URL = URL(string: UIApplication.openSettingsURLString) else {return status}
                UIApplication.shared.open(validSettingsURL, options: [:], completionHandler: nil)
            }
        }
        else {
            print("location services NOT available")
            print("update UI to show location is not available")
        }
        return status
    }
}

//MARK: CLLocationManager Delegate
extension LocationService: CLLocationManagerDelegate {
    
    func determineMyLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print("no locations")
            return }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("did fail with error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("did change Authorization: \(status)")
        
    }
}
