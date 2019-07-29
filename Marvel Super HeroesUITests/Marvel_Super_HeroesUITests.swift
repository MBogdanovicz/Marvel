//
//  Marvel_Super_HeroesUITests.swift
//  Marvel Super HeroesUITests
//
//  Created by Marcelo Bogdanovicz on 27/07/19.
//  Copyright © 2019 Marvel. All rights reserved.
//

import XCTest

class Marvel_Super_HeroesUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        
        super.setUp()
        continueAfterFailure = false
        
        app = XCUIApplication()
    }
    
    func test1Home() {
        app.launchArguments = ["-reset"]
        app.launch()
        
        let isDisplaying = app.tables["Characters View"].exists
        XCTAssertTrue(isDisplaying)
    }
    
    func test2Favorite() {
        let cell = app.cells.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
        
        let favButton = cell.buttons["favorite"]
        
        XCTAssertTrue(!favButton.isSelected)
        
        favButton.tap()
        XCTAssertTrue(favButton.isSelected)
    }
    
    func test3ViewDetail() {
        let cell = app.cells.element(boundBy: 0)
        cell.tap()
        
        let detailView = app.otherElements["Hero Detail View"]
        XCTAssertTrue(detailView.waitForExistence(timeout: 3))
        
        app.terminate()
    }
}
