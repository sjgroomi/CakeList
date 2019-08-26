//
//  CakeRetrieverTests.swift
//  Cake ListTests
//
//  Created by Stephen Groom on 26/08/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import XCTest
@testable import Cake_List

class CakeRetrieverTests: XCTestCase {
    private let manyCakesJSONData = """
[{"title":"Lemon cheesecake","desc":"A cheesecake made of lemon","image":"https://s3-eu-west-1.amazonaws.com/s3.mediafileserver.co.uk/carnation/WebFiles/RecipeImages/lemoncheesecake_lg.jpg"},{"title":"victoria sponge","desc":"sponge with jam","image":"http://www.bbcgoodfood.com/sites/bbcgoodfood.com/files/recipe_images/recipe-image-legacy-id--1001468_10.jpg"},{"title":"Carrot cake","desc":"Bugs bunnys favourite","image":"http://www.villageinn.com/i/pies/profile/carrotcake_main1.jpg"},{"title":"Banana cake","desc":"Donkey kongs favourite","image":"http://ukcdn.ar-cdn.com/recipes/xlarge/ff22df7f-dbcd-4a09-81f7-9c1d8395d936.jpg"},{"title":"Birthday cake","desc":"a yearly treat","image":"http://cornandco.com/wp-content/uploads/2014/05/birthday-cake-popcorn.jpg"},{"title":"Lemon cheesecake","desc":"A cheesecake made of lemon","image":"https://s3-eu-west-1.amazonaws.com/s3.mediafileserver.co.uk/carnation/WebFiles/RecipeImages/lemoncheesecake_lg.jpg"},{"title":"victoria sponge","desc":"sponge with jam","image":"http://www.bbcgoodfood.com/sites/bbcgoodfood.com/files/recipe_images/recipe-image-legacy-id--1001468_10.jpg"},{"title":"Carrot cake","desc":"Bugs bunnys favourite","image":"http://www.villageinn.com/i/pies/profile/carrotcake_main1.jpg"},{"title":"Banana cake","desc":"Donkey kongs favourite","image":"http://ukcdn.ar-cdn.com/recipes/xlarge/ff22df7f-dbcd-4a09-81f7-9c1d8395d936.jpg"},{"title":"Birthday cake","desc":"a yearly treat","image":"http://cornandco.com/wp-content/uploads/2014/05/birthday-cake-popcorn.jpg"},{"title":"Lemon cheesecake","desc":"A cheesecake made of lemon","image":"https://s3-eu-west-1.amazonaws.com/s3.mediafileserver.co.uk/carnation/WebFiles/RecipeImages/lemoncheesecake_lg.jpg"},{"title":"victoria sponge","desc":"sponge with jam","image":"http://www.bbcgoodfood.com/sites/bbcgoodfood.com/files/recipe_images/recipe-image-legacy-id--1001468_10.jpg"},{"title":"Carrot cake","desc":"Bugs bunnys favourite","image":"http://www.villageinn.com/i/pies/profile/carrotcake_main1.jpg"},{"title":"Banana cake","desc":"Donkey kongs favourite","image":"http://ukcdn.ar-cdn.com/recipes/xlarge/ff22df7f-dbcd-4a09-81f7-9c1d8395d936.jpg"},{"title":"Birthday cake","desc":"a yearly treat","image":"http://cornandco.com/wp-content/uploads/2014/05/birthday-cake-popcorn.jpg"},{"title":"Lemon cheesecake","desc":"A cheesecake made of lemon","image":"https://s3-eu-west-1.amazonaws.com/s3.mediafileserver.co.uk/carnation/WebFiles/RecipeImages/lemoncheesecake_lg.jpg"},{"title":"victoria sponge","desc":"sponge with jam","image":"http://www.bbcgoodfood.com/sites/bbcgoodfood.com/files/recipe_images/recipe-image-legacy-id--1001468_10.jpg"},{"title":"Carrot cake","desc":"Bugs bunnys favourite","image":"http://www.villageinn.com/i/pies/profile/carrotcake_main1.jpg"},{"title":"Banana cake","desc":"Donkey kongs favourite","image":"http://ukcdn.ar-cdn.com/recipes/xlarge/ff22df7f-dbcd-4a09-81f7-9c1d8395d936.jpg"},{"title":"Birthday cake","desc":"a yearly treat","image":"http://cornandco.com/wp-content/uploads/2014/05/birthday-cake-popcorn.jpg"}]
""".data(using: .utf8)!
    
    private struct MockSuccessDataFetcher: DataFetching {
        let data: Data
        
        func fetchData(completion: (Result<Data, Error>) -> Void) {
            completion(.success(data))
        }
    }
    
    func testCakeRetrieverSuccessfullyRetrievingJsonDataReturnsTwentyCakes() {
        let dataFetcher = MockSuccessDataFetcher(data: manyCakesJSONData)
        let cakeRetriever = CakeRetriever(dataFetcher: dataFetcher)
        //Expectation/wait is not strictly needed as the following code is
        //synchronous but as we're passing an escaping block it's probably
        //good practise to use them anyway.  Otherwise the test would probably
        //be exibiting too much awareness of the underlying implementation
        let expectation = self.expectation(description: "Completion called")
        cakeRetriever.retrieveCakes { result in
            switch result {
            case .success(let cakes):
                XCTAssertEqual(20, cakes.count)
            case .failure(let error):
                XCTFail("Unexpected error \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testCakeRetrieverSuccessfullyRetrievingInvalidJSONReturnsCodableError() {
        let invalidData = "invalidData".data(using: .utf8)!
        let dataFetcher = MockSuccessDataFetcher(data: invalidData)
        let cakeRetriever = CakeRetriever(dataFetcher: dataFetcher)
        let expectation = self.expectation(description: "Completion called")
        cakeRetriever.retrieveCakes { result in
            switch result {
            case .success:
                XCTFail("Unexpected success case, was expecting failure")
            case .failure(let error):
                XCTAssertTrue(error is DecodingError)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    private struct MockFailingDataFetcher: DataFetching {
        struct Error: Swift.Error { }
        
        func fetchData(completion: (Result<Data, Swift.Error>) -> Void) {
            completion(.failure(Error()))
        }
    }
    
    func testCakeRetrieverFailingToRetrieveDataReturnsError() {
        let cakeRetriever = CakeRetriever(dataFetcher: MockFailingDataFetcher())
        let expectation = self.expectation(description: "Completion called")
        cakeRetriever.retrieveCakes { result in
            switch result {
            case .success:
                XCTFail("Unexpected success case, was expecting failure")
            case .failure(let error):
                XCTAssertTrue(error is MockFailingDataFetcher.Error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
}
