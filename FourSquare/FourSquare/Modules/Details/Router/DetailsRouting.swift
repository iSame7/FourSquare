//
//  DetailsRouting.swift
//  FourSquare
//
//  Created by Sameh Mabrouk on 04/07/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

protocol DetailsRouting: class {
    func navigateToTipsModule(viewController: Presentable?, tips: [TipItem], venuePhotoURL: String?)
    func navigateToMapModule(navController: NavigationControlling?)
}
