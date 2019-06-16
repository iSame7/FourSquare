//
//  Tip.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 10/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

import Foundation

struct TipsRespose: Codable {
    let tips: [Tip]
}

struct Tip: Codable {
    let createdAt: String
    let text: String
    let userName: String
}

struct Stats: Codable {
    let tipCount: Int?
    let usersCount: Int?
    let checkinsCount: Int?
    let visitsCount: Int64?
}

struct Likes: Codable {
    let count: Int
}
