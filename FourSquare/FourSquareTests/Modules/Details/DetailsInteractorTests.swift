//
//  DetailsInteractorTests.swift
//  FourSquareTests
//
//  Created by Sameh Mabrouk on 18/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

@testable import FourSquare

import XCTest

class DetailsInteractorTests: XCTestCase {
    // MARK:- Test variables
    private let mockVenueService = MockVenueService()
    private var sut: DetailsInteractor!
    
    // MARK:- Test life cycle
    override func setUp() {
        sut = DetailsInteractor(venueService: mockVenueService)
    }
    
    func testFetchVenueDetailsSuccessfully() {
        sut.fetchVenueDetails(venueId: "4f019124a69d45461f2458e7") { (venue, error) in
            XCTAssertNotNil(venue)
            XCTAssertEqual(venue?.name, "Restaurant A")
            XCTAssertEqual(venue?.location.lat, 52.36795609763071)
            XCTAssertEqual(venue?.location.lng, 4.895555168247901)
            XCTAssertEqual(venue?.location.address, "Nieuwe Doelenstraat 20-22")
        }
    }
    
    func testFetchVenueDetailsUnSuccessfully() {
        sut.fetchVenueDetails(venueId: "", completion: { (venues, error) in
            XCTAssertNotNil(error)
            XCTAssertEqual(error, .noResponse)
        })
    }
}
