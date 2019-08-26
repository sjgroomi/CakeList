//
//  ImageFetcherTests.swift
//  Cake ListTests
//
//  Created by Stephen Groom on 26/08/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import XCTest
@testable import Cake_List

class ImageFetcherTests: XCTestCase {
    
    private let url = URL(string: "url")!
    
    func testCompletionCalledWithErrorForNonImageData() throws {
        let invalidData = "invalidData".data(using: .utf8)!
        let urlDataRetriever = Mocks.SuccessfulDataRetriever(data: invalidData)
        let imageFetcher = ImageFetcher(urlDataRetriever: urlDataRetriever)
        imageFetcher.fetchImage(url: url) { result in
            switch result {
            case .failure(let error):
                XCTAssertTrue(error is ImageFetcher.UnableToDownloadImageError)
            default:
                XCTFail()
            }
        }
    }
    
    func testCompletionCalledWithErrorForErrorResponse() throws {
        let urlDataRetriever = Mocks.ErrorDataRetriever()
        let imageFetcher = ImageFetcher(urlDataRetriever: urlDataRetriever)
        imageFetcher.fetchImage(url: url) { result in
            switch result {
            case .failure(let error):
                XCTAssertTrue(error is ImageFetcher.UnableToDownloadImageError)
            default:
                XCTFail()
            }
        }
    }
    
    func testCompletionCalledWithImageForSuccessResponse() throws {
        let urlDataRetriever = Mocks.SuccessfulDataRetriever(data: try imageData())
        let imageFetcher = ImageFetcher(urlDataRetriever: urlDataRetriever)
        imageFetcher.fetchImage(url: url) { result in
            switch result {
            case .failure:
                XCTFail()
            case .success:
                break
            }
        }
    }
    
    struct FileNotFoundError: Error { }
    
    private func imageData() throws -> Data {
        guard let url = Bundle(for: type(of: self)).url(forResource: "Mike",
                                                        withExtension: "jpg") else {
                                                            throw FileNotFoundError()
        }
        return try Data(contentsOf: url)
    }
}
