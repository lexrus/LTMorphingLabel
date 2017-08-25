//
//  LTMorphingLabelUITests.swift
//  LTMorphingLabelUITests
//
//  Created by Lex on 25/08/2017.
//  Copyright © 2017 lexrus.com. All rights reserved.
//

import XCTest
import LTMorphingLabel

class LTMorphingLabelUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testMonkeyTest() {
        let app = XCUIApplication()
        app.buttons["Evaporate"].tap()

        app.buttons["Fall"].tap()
        
        let morphinglabelStaticText = XCUIApplication().staticTexts["morphingLabel"]
        for _ in 0...20 {
            morphinglabelStaticText.tap()
        }
    }
    
    func testNilText() {
        let app = XCUIApplication()
        app.buttons["Clear"].tap()

        let label = app.staticTexts["morphingLabel"]

        guard label.exists else {
            XCTFail("must have a morphingLabel with accessibilityIdentifier 'morphingLabel'")
            return
        }

        app.buttons["Scale"].tap()
    }
    
}
