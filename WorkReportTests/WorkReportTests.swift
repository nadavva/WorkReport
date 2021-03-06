//
//  WorkReportTests.swift
//  WorkReportTests
//
//  Created by Nadav Vanunu on 10/04/2018.
//  Copyright © 2018 Nadav Vanunu. All rights reserved.
//

import XCTest
@testable import WorkReport

class WorkReportTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCalendarDataManager_lastDayForMonth() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(28, CalendarDataManager.sharedInstance.lastDayForMonth(month: 2, year: 2018))
        XCTAssertEqual(31, CalendarDataManager.sharedInstance.lastDayForMonth(month: 1, year: 2018))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
