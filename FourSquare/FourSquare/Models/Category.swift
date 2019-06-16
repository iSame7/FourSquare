//
//  Category.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 01/04/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

struct Category: Codable {
    let id: String
    let name: String
    let pluralName: String
    let shortName: String
    let icon: Icon
    struct Icon: Codable {
        let prefix: String?
        let suffix: String?
    }
    let primary: Bool?
}
