//
//  Delivery.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 01/04/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

struct Delivery: Codable {
    let id: String?
    let url: String?
    let provider: Provider?
    struct Provider: Codable {
        let name: String?
    }
}
