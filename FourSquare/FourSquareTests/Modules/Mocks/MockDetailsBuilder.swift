//
//  MockDetailsBuilder.swift
//  FourSquareTests
//
//  Created by Sameh Mabrouk on 17/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//


@testable import FourSquare

class MockDetailsBuilder: DetailsBuilding {
    func buildModuleWith(venue: Venue, venuePhotoURL: String?) -> FourSquare.Module? {
        return FourSquare.Module(viewController: DetailsViewController())
    }
}
