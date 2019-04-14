//
//  Venue.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 01/04/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

struct Venue: Codable {
    let id: String
    let name: String
    let contact: Contact
    let location: Location
    let categories: [Category]
    let verified: Bool
    let url: String?
}
