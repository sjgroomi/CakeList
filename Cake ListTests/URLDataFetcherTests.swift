//
//  URLDataFetcherTests.swift
//  Cake ListTests
//
//  Created by Stephen Groom on 26/08/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import XCTest
@testable import Cake_List

class URLDataFetcherTests: XCTestCase {
    
    private let url = URL(string: "url")!

    func testDataFetcherReturnsDataForResponseWithDataAndNoError() {
        let expectedData = "data".data(using: .utf8)!
        let dataFetcher = URLDataFetcher(dataRetriever: Mocks.SuccessfulDataRetriever(data: expectedData),
                                         url: url)
        let expectation = self.expectation(description: "Completion called")
        dataFetcher.fetchData { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(expectedData, data)
            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testDataFetcherReturnsErrorForResponseWithError() {
        let dataFetcher = URLDataFetcher(dataRetriever: Mocks.ErrorDataRetriever(), url: url)
        let expectation = self.expectation(description: "Completion called")
        dataFetcher.fetchData { result in
            switch result {
            case .success:
                XCTFail("Unaxpected success case, expecting failure")
            case .failure(let error):
                XCTAssertTrue(error is Mocks.ErrorDataRetriever.Error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    private struct ResponseWithoutDataOrErrorDataRetriever: URLDataRetrieving {
        func retrieveData(at url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
            let response = HTTPURLResponse(url: url,
                                           statusCode: 500,
                                           httpVersion: nil,
                                           headerFields: nil)
            completion(nil, response, nil)
        }
    }
    
    func testDataFetcherReturnsUnexpectedErrorForResponseWithNeitherDataOrError() {
        let dataFetcher = URLDataFetcher(dataRetriever: ResponseWithoutDataOrErrorDataRetriever(),
                                         url: url)
        let expectation = self.expectation(description: "Completion called")
        dataFetcher.fetchData { result in
            switch result {
            case .success:
                XCTFail("Unaxpected success case, expecting failure")
            case .failure(let error):
                XCTAssertTrue(error is URLDataFetcher.UnexpectedError)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

}
