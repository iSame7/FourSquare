//
//  DetailsBuilding.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 04/07/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

protocol DetailsBuilding: class {
    func buildModuleWith(venue: Venue, venuePhotoURL: String?) -> FourSquare.Module?
}
