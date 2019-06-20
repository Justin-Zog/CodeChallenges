//
//  CountdownUITests.swift
//  CountdownUITests
//
//  Created by Justin Herzog on 6/19/19.
//  Copyright © 2019 Justin Herzog. All rights reserved.
//

import XCTest

class CountdownUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testExample() {
        let countdownLabel = app.staticTexts["countdownLabel"]
        let beginButton = app.staticTexts["beginButton"]
        // Check that the text is right
        XCTAssertEqual("Ready", countdownLabel.label)
        XCTAssertEqual("Begin", beginButton.label)
        // Presses the button
        beginButton.tap()
        // Checks that the button's text is right
                XCTAssertEqual("Cancel", beginButton.label)
        XCUIApplication()/*@START_MENU_TOKEN@*/.buttons["beginButton"]/*[[".buttons[\"Begin\"]",".buttons[\"beginButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        waitForExpectations(timeout: 10.1, handler: nil) // waits ten seconds
        // Check that the text is right
        XCTAssertEqual("Ready", countdownLabel.label)
        XCTAssertEqual("Begin", beginButton.label)
    }

}
