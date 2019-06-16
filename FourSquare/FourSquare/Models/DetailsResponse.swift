//
//  DetailsResponse.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 11/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import Foundation

struct DetailsResult: Codable {
    let response: DetailsResponse
}

struct DetailsResponse: Codable {
    let venue: Venue
}
