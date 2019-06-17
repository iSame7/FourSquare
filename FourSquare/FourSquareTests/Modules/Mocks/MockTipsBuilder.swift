//
//  MockTipsBuilder.swift
//  FourSquareTests
//
//  Created by Sameh Mabrouk on 17/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

@testable import FourSquare

class MockTipsBuilder: TipsBuilding {
    func buildModuleWith(tips: [TipItem], venuePhotoURL: String?) -> FourSquare.Module? {
        return FourSquare.Module(viewController: TipsViewController())
    }
}
