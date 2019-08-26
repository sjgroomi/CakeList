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
    
    private let lemonCheeseCakeJsonData = """
{"title":"Lemon cheesecake","desc":"A cheesecake made of lemon","image":"https://s3-eu-west-1.amazonaws.com/s3.mediafileserver.co.uk/carnation/WebFiles/RecipeImages/lemoncheesecake_lg.jpg"}
""".data(using: .utf8)!

    func testLemonCheeseCakeDecodedFromJSONHasExpectedPropertyValues() throws {
        let decoder = JSONDecoder()
        let cake = try decoder.decode(Cake.self, from: lemonCheeseCakeJsonData)
        XCTAssertEqual("Lemon cheesecake", cake.title)
        XCTAssertEqual("A cheesecake made of lemon", cake.description)
        XCTAssertEqual("https://s3-eu-west-1.amazonaws.com/s3.mediafileserver.co.uk/carnation/WebFiles/RecipeImages/lemoncheesecake_lg.jpg",
                       cake.imageURL.absoluteString)
    }

}
