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
    let contact: Contact?
    let location: Location
    let categories: [Category]
    let verified: Bool?
    let url: String?
    let stats: Stats?
    let likes: Likes?
    let rating: Double?
    let hours: Hours?
    let photos: VenuePhotos?
}

struct Hours: Codable {
    let status: String?
}

struct RichStatus: Codable {
    let text: String?
}

struct VenuePhotos: Codable {
    let count: Int?
    let groups: [Group]?
}

struct Group: Codable {
    let type: String?
    let name: String?
    let count: Int?
    let items: [Photo]?
}
