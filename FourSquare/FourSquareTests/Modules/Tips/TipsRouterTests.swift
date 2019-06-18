//
//  TipsRouterTests.swift
//  FourSquareTests
//
//  Created by Sameh Mabrouk on 18/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

@testable import FourSquare

import XCTest

class TipsRouterTests: XCTestCase {
    // MARK:- Test variables
    private let mockTipsViewController = MockTipsViewController()
    private var sut: TipsRouter!
    
    // MARK:- Test life cycle
    override func setUp() {
        sut = TipsRouter()
    }
    
    func testdidNavigateToDetailsModule() {
        sut.navigateToDetailsModule(viewController: mockTipsViewController)
        
        XCTAssertTrue(mockTipsViewController.isDismissed)
    }
}
