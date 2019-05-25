//
//  Photo.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 20/05/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import Foundation

struct VenuePhotoResponse: Codable {
    let response: PhotoResponse
}

struct PhotoResponse: Codable {
    let photos: Photos?
}

struct Photos: Codable {
    let count: Int 
    let items: [Photo]
}

struct Photo: Codable {
    let id: String
    let prefix: String
    let suffix: String
    let width: Int
    let height: Int
    let visibility: String
    let source: Source
}

struct Source: Codable {
    let name: String?
    let url: String?
}
