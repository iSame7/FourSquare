//
//  DetailsPresenterTests.swift
//  FourSquareTests
//
//  Created by Sameh Mabrouk on 18/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

@testable import FourSquare

import XCTest

class DetailsPresenterTests: XCTestCase {
    // MARK:- Test variables
    private let mockDetailsInteractor = MockDetailsInteractor()
    private let mockDetailsRouter = MockDetailsRouter()
    private let mockMapURLHandler = MokcMapURLHandler()
    private let mockDetailsViewController = MockDetailsViewController1()
    private var sut: DetailsPresenter!
    
    // MARK:- Test life cycle
    override func setUp() {
        sut = DetailsPresenter(view: mockDetailsViewController, interactor: mockDetailsInteractor, mapURLHandler: mockMapURLHandler, router: mockDetailsRouter)
    }
    
    func testGetVenueDetailsSuccessfully() {
        sut.getVenueDetails(venueId: "4f019124a69d45461f2458e7")
        XCTAssertNotNil(mockDetailsViewController.viewModel)
        XCTAssertNotNil(mockDetailsViewController.viewModel?.venue)
        XCTAssertEqual(mockDetailsViewController.viewModel?.venue.name, "Starbucks")
        XCTAssertEqual(mockDetailsViewController.viewModel?.venue.location.lat, 52.36607678472145)
        XCTAssertEqual(mockDetailsViewController.viewModel?.venue.location.lng, 4.897430803910262)
        XCTAssertEqual(mockDetailsViewController.viewModel?.venue.location.address, "Utrechtsestraat 9")
    }
    
    func testShowAppleMap() {
        sut.showMap(type: .apple, location: Location(lat: 52.36795609763071, lng: 4.895555168247901, address: "Nieuwe Doelenstraat 20-22", crossStreet: nil, distance: nil, postalCode: "1012 CP", cc: nil, city: "Amsterdam", state: "North Holland", country: "Netherlands"))
        XCTAssertTrue(mockMapURLHandler.didShowAppleMap)
        XCTAssertFalse(mockMapURLHandler.didShowGoogleMap)
        XCTAssertEqual(mockMapURLHandler.shownLocation.address, "Nieuwe Doelenstraat 20-22")
        XCTAssertEqual(mockMapURLHandler.shownLocation.lat, 52.36795609763071)
        XCTAssertEqual(mockMapURLHandler.shownLocation.lng, 4.895555168247901)
    }
    
    func testShowGoogleMap() {
        sut.showMap(type: .google, location: Location(lat: 52.36795609763071, lng: 4.895555168247901, address: "Nieuwe Doelenstraat 20-22", crossStreet: nil, distance: nil, postalCode: "1012 CP", cc: nil, city: "Amsterdam", state: "North Holland", country: "Netherlands"))
        XCTAssertTrue(mockMapURLHandler.didShowGoogleMap)
        XCTAssertFalse(mockMapURLHandler.didShowAppleMap)
        XCTAssertEqual(mockMapURLHandler.shownLocation.address, "Nieuwe Doelenstraat 20-22")
        XCTAssertEqual(mockMapURLHandler.shownLocation.lat, 52.36795609763071)
        XCTAssertEqual(mockMapURLHandler.shownLocation.lng, 4.895555168247901)
    }
    
    func testIsTipsModulePushedInNavigationController() {
        sut.showTipsViewController(tips: [TipItem(createdAt: 1278634077, text: "My girlfriend dumped me after I took her on a date here... she was a skank anyway-this place awesome!", user: nil)], venuePhotoURL: nil)
        XCTAssertTrue(mockDetailsRouter.didNavigateToTipsModule)
    }
    
    func testIsDetailsModuleDismissed() {
        sut.dismiss()
        XCTAssertTrue(mockDetailsRouter.didNavigateToMapModule)
    }
}

private class MockDetailsInteractor: DetailsInteracting {
    var presenter: DetailsPresenting?
    
    func fetchVenueDetails(venueId: String, completion: @escaping (Venue?, FoursquareError?) -> Void) {
        if !venueId.isEmpty {
            let mockVenue1 = Venue(id: "4f019124a69d45461f2458e7", name: "Starbucks", contact: nil, location: Location(lat: 52.36607678472145, lng: 4.897430803910262, address: "Utrechtsestraat 9", crossStreet: nil, distance: nil, postalCode: "1017 CV", cc: nil, city: "Amsterdam", state: "North Holland", country: "Netherlands"), categories: [Category(id: "4bf58dd8d48988d16d941735", name: "Coffee Shops", pluralName: "Coffee Shops", shortName: "Coffee Shops", icon: Category.Icon(prefix: "https://ss3.4sqi.net/img/categories_v2/food/coffeeshop_", suffix: ".png"), primary: nil)], verified: false, url: nil, stats: nil, likes: nil, rating: nil, hours: nil, photos: nil, tips: nil)
            completion(mockVenue1, nil)
        } else {
            completion(nil, .noResponse)
        }
    }
}

private class MockDetailsRouter: DetailsRouting {
    var didNavigateToTipsModule = false
    var didNavigateToMapModule = false
    func navigateToMapModule(navController: NavigationControlling?) {
        didNavigateToMapModule = true
    }
    
    func navigateToTipsModule(viewController: Presentable?, tips: [TipItem], venuePhotoURL: String?) {
        didNavigateToTipsModule = true
    }
}

private class MokcMapURLHandler: MapURLHandling {
    var didShowAppleMap = false
    var didShowGoogleMap = false
    var shownLocation: Location!
    
    func openMap(location: Location, type: MapType) {
        switch type {
        case .apple:
            didShowAppleMap = true
            shownLocation = location
        case .google:
            didShowGoogleMap = true
            shownLocation = location
        }
    }
}

class MockDetailsViewController1: UIViewController, DetailsViewable {
    var presenter: DetailsPresenting?
    var viewModel: DetailsViewController.ViewModel!
    var error: FoursquareError!
    func updateWith(viewModel: DetailsViewController.ViewModel) {
        self.viewModel = viewModel
    }
    
    func updateWith(error: FoursquareError) {
        self.error = error
    }
}
