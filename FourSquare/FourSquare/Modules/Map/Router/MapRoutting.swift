//
//  MapRoutable.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 25/05/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

protocol MapRoutting: class {
    func navigateToDetailsModule(navController: NavigationControlling?, venue: Venue, venuePhotoURL: String?)
}
