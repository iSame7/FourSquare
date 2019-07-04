//
//  MapPresenter.swift
//  FourSquareTests
//
//  Created by Sameh Mabrouk on 17/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

@testable import FourSquare

import XCTest

class MapPresenterTests: XCTestCase {
    // MARK: - Test variables
    private let mockMapViewController = MockMapViewController()
    private let mockMapInteractor = MockMapInteractor()
    private let mockDetailsModuleBuilder = MockDetailsBuilder()
    private let mockNavigationController = MockNavigationController()
    private var mockRouter = MockRouter()
    private var sut: MapPresenter?
    
    private let mockVenue = Venue(id: "123", name: "Restaurant A", contact: nil, location: Location(lat: 52.36795609763071, lng: 4.895555168247901, address: "Nieuwe Doelenstraat 20-22", crossStreet: nil, distance: nil, postalCode: "1012 CP", cc: nil, city: "Amsterdam", state: "North Holland", country: "Netherlands"), categories: [Category(id: "4bf58dd8d48988d16d941735", name: "Café", pluralName: "Cafés", shortName: "Café", icon: Category.Icon(prefix: "https://ss3.4sqi.net/img/categories_v2/food/cafe_", suffix: ".png"), primary: nil)], verified: false, url: nil, stats: nil, likes: nil, rating: nil, hours: nil, photos: nil, tips: nil)
    
    // MARK: - Test life cycle
    override func setUp() {
        sut = MapPresenter(view: mockMapViewController, mapInteractor: mockMapInteractor, router: mockRouter)
    }
    
    // MARK: - Tests
    func testIsMapViewLoaded() {
        sut?.viewDidLoad()
        
        XCTAssertNotNil(mockMapViewController.locationViewModel)
        XCTAssertEqual(mockMapViewController.locationViewModel.lat, 52.36795609763071)
        XCTAssertEqual(mockMapViewController.locationViewModel.lng, 4.895555168247901)
    }
    
    func testGetRestaurantsArountCoordinate() {
        sut?.getRestaurantsAround(coordinate: "52.362305405787325,4.8999109843211")
        XCTAssertNotNil(mockMapViewController.venues)
        XCTAssertEqual(mockMapViewController.venues.count, 2)
        XCTAssertEqual(mockMapViewController.venues.first?.name, "Restaurant A")
        XCTAssertEqual(mockMapViewController.venues.first?.location.lat, 52.36795609763071)
        XCTAssertEqual(mockMapViewController.venues.first?.location.lng, 4.895555168247901)
        XCTAssertEqual(mockMapViewController.venues.first?.location.address, "Nieuwe Doelenstraat 20-22")
        XCTAssertEqual(mockMapViewController.venues[1].name, "Starbucks")
        XCTAssertEqual(mockMapViewController.venues[1].location.lat, 52.36607678472145)
        XCTAssertEqual(mockMapViewController.venues[1].location.lng, 4.897430803910262)
        XCTAssertEqual(mockMapViewController.venues[1].location.address, "Utrechtsestraat 9")
    }
    
    func testGetRestaurantsAroundCoordinateWithError() {
        sut?.getRestaurantsAround(coordinate: "")
        
        XCTAssertNotNil(mockMapViewController.error)
        XCTAssertEqual(mockMapViewController.error, .noResponse)
    }
    
    func testGetPhotosForVenue() {
        sut?.getPhotos(venueId: "4f019124a69d45461f2458e7")
        
        XCTAssertNotNil(mockMapViewController.venuePhotoURL)
        XCTAssertNotNil(mockMapViewController.venueId)
        
        XCTAssertEqual(mockMapViewController.venuePhotoURL, "https://fastly.4sqi.net/img/general/700x500/WfIypTz_PxPvh75QSIBwomCu-jK_72UDiBauHc6L1dU.jpg")
    }
    
    func testIsDetailsModulePushedInNavigationController() {
        sut?.showDetailsViewController(venue: mockVenue, venuePhotoURL: "")
        
        XCTAssertTrue(mockRouter.didGoToDetailsModule)
    }
}

private class MockMapViewController: UIViewController, MapViewable {
    var locationViewModel: MapViewController.LocationViewModel!
    var venues: [Venue]!
    var error: FoursquareError!
    var venuePhotoURL: String!
    var venueId: String!
    
    func update(_ model: [Venue]) {
        venues = model
    }
    
    func showError(error: FoursquareError) {
        self.error = error
    }
    
    func update(with photo: String, for venueId: String) {
        venuePhotoURL = photo
        self.venueId = venueId
    }
    
    func updateUserLocation(_ locationViewModel: MapViewController.LocationViewModel) {
        self.locationViewModel = locationViewModel
    }
}

private class MockMapInteractor: MapInteracting {
    func getRestaurantsAround(coordinate: String, completion: @escaping ([Venue]?, FoursquareError?) -> Void) {
        if !coordinate.isEmpty {
            let mockVenue1 = Venue(id: "123", name: "Restaurant A", contact: nil, location: Location(lat: 52.36795609763071, lng: 4.895555168247901, address: "Nieuwe Doelenstraat 20-22", crossStreet: nil, distance: nil, postalCode: "1012 CP", cc: nil, city: "Amsterdam", state: "North Holland", country: "Netherlands"), categories: [Category(id: "4bf58dd8d48988d16d941735", name: "Café", pluralName: "Cafés", shortName: "Café", icon: Category.Icon(prefix: "https://fastly.4sqi.net/img/general/", suffix: "/WfIypTz_PxPvh75QSIBwomCu-jK_72UDiBauHc6L1dU.jpg"), primary: nil)], verified: false, url: nil, stats: nil, likes: nil, rating: nil, hours: nil, photos: nil, tips: nil)
            
            let mockVenue2 = Venue(id: "4f019124a69d45461f2458e7", name: "Starbucks", contact: nil, location: Location(lat: 52.36607678472145, lng: 4.897430803910262, address: "Utrechtsestraat 9", crossStreet: nil, distance: nil, postalCode: "1017 CV", cc: nil, city: "Amsterdam", state: "North Holland", country: "Netherlands"), categories: [Category(id: "4bf58dd8d48988d16d941735", name: "Coffee Shops", pluralName: "Coffee Shops", shortName: "Coffee Shops", icon: Category.Icon(prefix: "https://ss3.4sqi.net/img/categories_v2/food/coffeeshop_", suffix: ".png"), primary: nil)], verified: false, url: nil, stats: nil, likes: nil, rating: nil, hours: nil, photos: nil, tips: nil)
            completion([mockVenue1, mockVenue2], nil)
        } else {
            completion(nil, .noResponse)
        }
    }
    
    func getVenuePhotos(venueId: String, completion: @escaping ([Photo]) -> Void) {
        let photo1 = Photo(id: "4fe03279e4b0690a86767319", prefix: "https://fastly.4sqi.net/img/general/", suffix: "/WfIypTz_PxPvh75QSIBwomCu-jK_72UDiBauHc6L1dU.jpg", width: 720, height: 540, visibility: "public", source: Source(name: "Foursquare for iOS", url: "https://foursquare.com/download/#/iphone"))
        let photo2 = Photo(id: "51dbe1e9498e361de7fccbb7", prefix: "https://fastly.4sqi.net/img/general/", suffix: "/9664729_cr9GMPE2yxpPO_e4CFx5xtyNdjWqNQa06SZBO3aFbio.jpg", width: 720, height: 720, visibility: "public", source: Source(name: "Foursquare for iOS", url: "https://foursquare.com/download/#/iphone"))
        completion([photo1, photo2])
    }
    
    func determineUserLocation(completion: @escaping UserLocationBlock) {
        completion(Location(lat: 52.36795609763071, lng: 4.895555168247901, address: "Nieuwe Doelenstraat 20-22", crossStreet: nil, distance: nil, postalCode: nil, cc: nil, city: nil, state: nil, country: nil))
    }
}

private class MockRouter: MapRoutting {
    var didGoToDetailsModule = false
    func navigateToDetailsModule(navController: NavigationControlling?, venue: Venue, venuePhotoURL: String?) {
        didGoToDetailsModule = true
    }
}
