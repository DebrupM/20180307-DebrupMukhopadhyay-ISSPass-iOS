//
//  ISSPassUITests.swift
//  ISSPassUITests
//
//  Created by Debrup Mukhopadhyay on 06/03/18.
//  Copyright © 2018 debrup. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ISSPass

class ISSPassUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        // Network connection complete expectation
        let expectation = self.expectation(description: "Loading")
        DataManager.getISSPassTimes(over: CLLocationCoordinate2D(latitude: 22, longitude: 88), completionClosure: { (success, data, error) in
            XCTAssertTrue(success)
            XCTAssertNotNil(data)
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 5.0) { (error) in
            if (error==nil) {
                XCTAssertTrue(true)
            } else {
                XCTAssertTrue(false)
            }
        }
    }
    
}
