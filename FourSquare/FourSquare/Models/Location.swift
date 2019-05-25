//
//  Location.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 01/04/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

struct Location: Codable {
    let lat: Double
    let lng: Double
    let address: String?
    let crossStreet: String?
    let distance: Double?
    let postalCode: String?
    let cc: String?
    let city: String?
    let state: String?
    let country: String?
}
