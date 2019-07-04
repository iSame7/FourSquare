//
//  DetailsPresenting.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 04/07/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

protocol DetailsPresenting: class {
    func getVenueDetails(venueId: String, venuePhotoURL: String?)
    func showMap(type: MapType, location: Location)
    func showTipsViewController(tips: [TipItem], venuePhotoURL: String?)
    func dismiss()
}
