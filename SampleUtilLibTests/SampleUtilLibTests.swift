//
//  SampleUtilLibTests.swift
//  SampleUtilLibTests
//
//  Created by Bao Nguyen on 2020/06/30.
//  Copyright © 2020 Bao Nguyen. All rights reserved.
//

import XCTest
@testable import SampleUtilLib

class SampleUtilLibTests: XCTestCase {
    
    var view: UIView!
    
    override func setUp() {
        view = UIView()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCornerRadius() {
        view.cornerRadius = 10
        XCTAssertEqual(view.cornerRadius, 10)
    }
    
    func testBorderWidth() {
        view.borderWidth = 10
        XCTAssertEqual(view.borderWidth, 10)
    }
    
    func testBorderColor() {
        view.borderColor = .red
        XCTAssertEqual(view.borderColor, UIColor.red)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
