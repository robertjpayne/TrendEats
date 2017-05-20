
//
//  InstarantTests.swift
//  InstarantTests
//
//  Created by Christopher Dunaetz on 12/21/15.
//  Copyright © 2015 Chris Dunaetz. All rights reserved.
//

import XCTest
@testable import Instarant

class InstarantTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFoursquareRestaurantsSucceeds() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let exp = expectation(description: "")
        FoursquareAPI.getNearbyRestaurantIDs("34", longitude: "-118") { (array, city, success) in
            exp.fulfill()
            XCTAssertTrue(success, "this is the city: \(city)")
        }
        
        waitForExpectations(timeout: 10) { error in

        }

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    
}
