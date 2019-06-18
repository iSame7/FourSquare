//
//  TipsPresenterTests.swift
//  FourSquareTests
//
//  Created by Sameh Mabrouk on 18/06/2019.
//  Copyright © 2019 VanMoof. All rights reserved.
//

@testable import FourSquare

import XCTest

class TipsPresenterTests: XCTestCase {
    // MARK:- Test variables
    private let mockTipsViewController = MockTipsViewController()
    private let mockTipsRouter = MockTipsRouter()
    private var sut: TipsPresenter!
    
    // MARK:- Test life cycle
    override func setUp() {
        sut = TipsPresenter(view: mockTipsViewController, interactor: nil, router: mockTipsRouter)
    }
    
    func testTipsModuleIsDismissed() {
        sut.dismiss()
        XCTAssertTrue(mockTipsRouter.didNavigateToDetailsModule)
    }
}

private class MockTipsRouter: TipsRouting {
    var didNavigateToDetailsModule = false
    func navigateToDetailsModule(viewController: Presentable?) {
        didNavigateToDetailsModule = true
    }
}
