//
//  Mocks.swift
//  Cake ListTests
//
//  Created by Stephen Groom on 26/08/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import Foundation
@testable import Cake_List

enum Mocks {
    struct SuccessfulDataRetriever: URLDataRetrieving {
        let data: Data
        func retrieveData(at url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
            completion(data, nil, nil)
        }
    }
    
    struct ErrorDataRetriever: URLDataRetrieving {
        struct Error: Swift.Error { }
        
        func retrieveData(at url: URL, completion: @escaping (Data?, URLResponse?, Swift.Error?) -> Void) {
            completion(nil, nil, Error())
        }
    }
}
