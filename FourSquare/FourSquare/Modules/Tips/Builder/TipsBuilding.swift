//
//  TipsBuilding.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 05/07/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

protocol TipsBuilding: class {
    func buildModuleWith(tips: [TipItem], venuePhotoURL: String?) -> FourSquare.Module?
}
