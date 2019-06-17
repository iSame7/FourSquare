//
//  MapInteractorTests.swift
//  FourSquareTests
//
//  Created by Sameh Mabrouk on 17/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

@testable import FourSquare

import XCTest

class MapInteractorTests: XCTestCase {
    // MARK: - Test variables
    private let mockLocationService = MockLocationService()
    private let mockVenueService = MockVenueService()
    
    var sut: MapInteractor!
    
    override func setUp() {
        sut = MapInteractor(locationService: mockLocationService, venueService: mockVenueService)
    }
    
    func testGetRestaurantAroundSuccessfully() {
        sut.getRestaurantsAround(coordinate: "52.362305405787325,4.8999109843211") { (venues, error) in
            XCTAssertNotNil(venues)
            XCTAssertEqual(venues?.count, 2)
            XCTAssertEqual(venues?.first?.name, "Restaurant A")
            XCTAssertEqual(venues?.first?.location.lat, 52.36795609763071)
            XCTAssertEqual(venues?.first?.location.lng, 4.895555168247901)
            XCTAssertEqual(venues?.first?.location.address, "Nieuwe Doelenstraat 20-22")
            XCTAssertEqual(venues?[1].name, "Starbucks")
            XCTAssertEqual(venues?[1].location.lat, 52.36607678472145)
            XCTAssertEqual(venues?[1].location.lng, 4.897430803910262)
            XCTAssertEqual(venues?[1].location.address, "Utrechtsestraat 9")
        }
    }
    
    func testGetRestaurantAroundUnSuccessfully() {
        sut?.getRestaurantsAround(coordinate: "", completion: { (venues, error) in
            XCTAssertNotNil(error)
            XCTAssertEqual(error, .noResponse)
        })
    }
    
    func testGetVenuePhotosSuccessfully() {
        sut.getVenuePhotos(venueId: "4f019124a69d45461f2458e7") { (photos) in
            XCTAssertNotNil(photos)
            XCTAssertEqual(photos.count, 2)
            XCTAssertEqual(photos[0].id, "4fe03279e4b0690a86767319")
            XCTAssertEqual(photos[0].prefix, "https://fastly.4sqi.net/img/general/")
            XCTAssertEqual(photos[0].suffix, "/WfIypTz_PxPvh75QSIBwomCu-jK_72UDiBauHc6L1dU.jpg")
            XCTAssertEqual(photos[0].width, 720)
            XCTAssertEqual(photos[0].height, 540)
        }
    }
    
    func testDetermineUserLocation() {
        mockLocationService.isLocationServiceEnabled = true
        sut.determineUserLocation { location in
            XCTAssertNotNil(location)
            XCTAssertEqual(location.address, "Nieuwe Doelenstraat 20-22")
            XCTAssertEqual(location.lat, 52.36795609763071)
            XCTAssertEqual(location.lng, 4.895555168247901)
        }
    }
    
    
    func testDetermineUserLocationUnsuccessfully() {
        mockLocationService.isLocationServiceEnabled = false
        sut.determineUserLocation { location in
            XCTAssertEqual(location.lng, 0.0)
            XCTAssertEqual(location.lat, 0.0)
            XCTAssertNil(location.address)
            XCTAssertNil(location.postalCode)
        }
    }
}

private class MockLocationService: LocationServiceChecking {
    var isLocationServiceEnabled = false
    enum Auth {
        case authorized
        case denied
    }
    
    var auth: Auth!
    
    func requestAuthorization() {
        if isLocationServiceEnabled {
            auth = .authorized
        } else {
            auth = .denied
        }
    }
    
    func requestUserLocation(completion: @escaping UserLocationBlock) {
        switch auth {
        case .authorized?:
            completion(Location(lat: 52.36795609763071, lng: 4.895555168247901, address: "Nieuwe Doelenstraat 20-22", crossStreet: nil, distance: nil, postalCode: "1012 CP", cc: nil, city: "Amsterdam", state: "North Holland", country: "Netherlands"))
        default:
            completion(Location(lat: 0.0, lng: 0.0, address: nil, crossStreet: nil, distance: nil, postalCode: nil, cc: nil, city: nil, state: nil, country: nil))
            break
        }
    }
}


