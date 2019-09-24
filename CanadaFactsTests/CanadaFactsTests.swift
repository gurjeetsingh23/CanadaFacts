//
//  CanadaFactsTests.swift
//  CanadaFactsTests
//
//  Created by Julka, Gurjeet on 23/9/19.
//  Copyright © 2019 Gurjeet Singh Julka. All rights reserved.
//

import XCTest
@testable import CanadaFacts

class CanadaFactsTests: XCTestCase {
    let homeViewController = HomeViewController()
    let datalayer = FactsDataLayer()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testDataLayer() {
        let expectation = XCTestExpectation (description: "Data should be fetched")
        datalayer.fetchHomeData { success, error  in
            if success {
                XCTAssertTrue(true)
            } else if error != nil {
                XCTAssertFalse(true)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
