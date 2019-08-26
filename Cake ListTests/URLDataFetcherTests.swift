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
    
    private struct SuccessfulDataRetriever: URLDataRetrieving {
        let data: Data
        func retrieveData(at url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
            completion(data, nil, nil)
        }
    }

    func testDataFetcherReturnsDataForResponseWithDataAndNoError() {
        let expectedData = "data".data(using: .utf8)!
        let dataFetcher = URLDataFetcher(dataRetriever: SuccessfulDataRetriever(data: expectedData),
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
    
    private struct ErrorDataRetriever: URLDataRetrieving {
        struct Error: Swift.Error { }
        
        func retrieveData(at url: URL, completion: @escaping (Data?, URLResponse?, Swift.Error?) -> Void) {
            completion(nil, nil, Error())
        }
    }
    
    func testDataFetcherReturnsErrorForResponseWithError() {
        let dataFetcher = URLDataFetcher(dataRetriever: ErrorDataRetriever(), url: url)
        let expectation = self.expectation(description: "Completion called")
        dataFetcher.fetchData { result in
            switch result {
            case .success:
                XCTFail("Unaxpected success case, expecting failure")
            case .failure(let error):
                XCTAssertTrue(error is ErrorDataRetriever.Error)
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
