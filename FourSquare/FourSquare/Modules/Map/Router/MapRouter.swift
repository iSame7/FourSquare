//
//  MapRouter.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 25/05/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//
import UIKit

class MapRouter: MapRoutable {
    private weak var detailsModuleBuilder: DetailsBuilding?
    weak var navController: NavigationControlling?

    init(detailsModuleBuilder: DetailsBuilding?) {
        self.detailsModuleBuilder = detailsModuleBuilder
    }
    
    func navigateToDetailsModule(navController: NavigationControlling?, venue: Venue, venuePhotoURL: String?) {
        self.navController = navController
        if let viewController = detailsModule(venue: venue, venuePhotoURL: venuePhotoURL)?.viewController {
            navController?.pushViewController(viewController, animated: true)
        }
    }
    
    func detailsModule(venue: Venue, venuePhotoURL: String?) -> FourSquare.Module? {
        return detailsModuleBuilder?.buildModuleWith(venue: venue, venuePhotoURL: venuePhotoURL)
    }
}
