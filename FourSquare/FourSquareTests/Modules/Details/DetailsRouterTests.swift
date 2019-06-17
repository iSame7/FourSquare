//
//  DetailsRouterTests.swift
//  FourSquareTests
//
//  Created by Sameh Mabrouk on 17/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

@testable import FourSquare

import XCTest

class DetailsRouterTests: XCTestCase {
    // MARK:- Test variables
    private let mockTipsBuilder = MockTipsBuilder()
    private let mockDetailsViewController = MockDetailsViewController()
    private let mockNavigationController =  MockNavigationController()
    private var sut: DetailsRouter!
    
    // MARK:- Test life cycle
    override func setUp() {
        sut = DetailsRouter(tipsModuleBuilder: mockTipsBuilder)
    }
    
    // MARK: - Tests
    func testIsTipsModulePresented() {
        
        sut.navigateToTipsModule(viewController: mockDetailsViewController, tips: [TipItem(createdAt: 123456, text: "", user: nil)], venuePhotoURL: nil)
        XCTAssertTrue(mockDetailsViewController.isPresented)
        XCTAssertNotNil(mockDetailsViewController.viewControllerPresented as? TipsViewController)
    }
    
    func testDidNavigateToMapViewController() {
        sut.navigateToMapModule(navController: mockNavigationController)
        XCTAssertTrue(mockNavigationController.isPoped)
        XCTAssertNotNil(mockNavigationController.currentViewController)
        XCTAssertTrue((mockNavigationController.currentViewController?.isKind(of: MapViewController.self))!)
    }
}
