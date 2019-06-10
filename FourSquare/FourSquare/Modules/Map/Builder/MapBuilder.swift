//
//  MapBuilder.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 26/03/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import Swinject
import CoreLocation

class MapBuilder: MapBuilding {
    private let container: Container
    
    init(container: Container) {
        self.container = container
        Container.loggingFunction = nil
    }
    
    func buildMapModule() -> FourSquare.Module? {
        registerView()
        registerLocationService()
        registerVenueService()
        registerInteractor()
        registerRouter()
        registerPresenter()
        
        guard let mapViewController = container.resolve(MapViewable.self) as? UIViewController  else { return nil }
        let navController = UINavigationController(rootViewController: mapViewController)
        return FourSquare.Module(viewController: navController)
    }
    
    private func registerView() {
        container.register(MapViewable.self, factory: { _ in
            MapViewController.instantiate()
        }).initCompleted({ (r, view) in
            if let mapViewController = view as? MapViewController {
                mapViewController.presenter = r.resolve(MapPresenting.self)!
            }
        }).inObjectScope(.container)
    }
    
    private func registerInteractor() {
        container.register(MapInteracting.self, factory: { r in
            MapInteractor(locationService: r.resolve(LocationServiceChecking.self)!, venueService: r.resolve(VenueFetching.self)!)
        }).initCompleted ({ (r, interactor) in
            if let mapInteractor = interactor as? MapInteractor {
                mapInteractor.presenter = r.resolve(MapPresenting.self)
            }
        }).inObjectScope(.container)
    }
    
    private func registerPresenter() {
        container.register(MapPresenting.self, factory: { r in
            MapPresenter(view: r.resolve(MapViewable.self), mapInteractor: r.resolve(MapInteracting.self)!, router: r.resolve(MapRoutable.self)!)
        }).inObjectScope(.container)
    }
    
    private func registerVenueService() {
        container.register(VenueFetching.self, factory: { _ in
            VenuService()
        }).inObjectScope(.container)
    }
    
    private func registerLocationService() {
        container.register(CLLocationManager.self, factory: { _ in CLLocationManager() }).initCompleted({ _, manager in
            manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            manager.distanceFilter = 5
            manager.allowsBackgroundLocationUpdates = true
            manager.activityType = .fitness
            if #available(iOS 11.0, *) {
                manager.showsBackgroundLocationIndicator = false
            }
        }).inObjectScope(.container)
        
        container.register(LocationServiceChecking.self) { r in
            LocationService(locationManager: r.resolve(CLLocationManager.self)!)
        }
    }
    
    func registerRouter() {
        container.register(MapRoutable.self, factory: { r in
            MapRouter(detailsModuleBuilder: r.resolve(DetailsBuilding.self))
        }).inObjectScope(.container)
    }
}
