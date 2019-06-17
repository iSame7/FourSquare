//
//  MapRouterTests.swift
//  FourSquareTests
//
//  Created by Sameh Mabrouk on 17/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

@testable import FourSquare

import XCTest

class MapRouterTests: XCTestCase {
    // MARK: - test variables
    private let mockDetailsModuleBuilder = MockDetailsBuilder()
    private let mockNavigationController = MockNavigationController()
    private let mockVenue = Venue(id: "123", name: "Restaurant A", contact: nil, location: Location(lat: 52.36795609763071, lng: 4.895555168247901, address: "Nieuwe Doelenstraat 20-22", crossStreet: nil, distance: nil, postalCode: "1012 CP", cc: nil, city: "Amsterdam", state: "North Holland", country: "Netherlands"), categories: [Category(id: "4bf58dd8d48988d16d941735", name: "Café", pluralName: "Cafés", shortName: "Café", icon: Category.Icon(prefix: "https://ss3.4sqi.net/img/categories_v2/food/cafe_", suffix: ".png"), primary: nil)], verified: false, url: nil, stats: nil, likes: nil, rating: nil, hours: nil, photos: nil, tips: nil)
    var sut: MapRouter?
    
    override func setUp() {
        sut = MapRouter(detailsModuleBuilder: mockDetailsModuleBuilder)
    }
    
    func testIsDetailsModulePushedInNavigationController() {
        sut?.navigateToDetailsModule(navController: mockNavigationController, venue: mockVenue, venuePhotoURL: nil)
        XCTAssertTrue(mockNavigationController.isPushCalled)
        XCTAssertNotNil(mockNavigationController.viewControllerPushed as? DetailsViewController)
    }
}

private class MockNavigationController: NavigationControlling {
    
    var isPushCalled = false
    var isPoped = false
    var viewControllerPushed: UIViewController?
    
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        isPushCalled = true
        viewControllerPushed = viewController
    }
    
    func popViewController(animated: Bool) -> UIViewController? {
        isPoped = true
        
        return UIViewController()
    }
    
}

private class MockDetailsBuilder: DetailsBuilding {
    func buildModuleWith(venue: Venue, venuePhotoURL: String?) -> FourSquare.Module? {
        return FourSquare.Module(viewController: DetailsViewController())
    }
}
