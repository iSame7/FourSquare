//
//  DetailsInteracting.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 04/07/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

protocol DetailsInteracting: class {
    var presenter: DetailsPresenting?  { get set }
    func fetchVenueDetails(venueId: String, completion: @escaping (Venue?, FoursquareError?) -> Void)
}
