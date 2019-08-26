//
//  CakeTests.swift
//  Cake ListTests
//
//  Created by Stephen Groom on 26/08/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import XCTest
@testable import Cake_List

class CakeTests: XCTestCase {
    
    private let lemonCheeseCake = """
{"title":"Lemon cheesecake","desc":"A cheesecake made of lemon","image":"https://s3-eu-west-1.amazonaws.com/s3.mediafileserver.co.uk/carnation/WebFiles/RecipeImages/lemoncheesecake_lg.jpg"}
"""

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
