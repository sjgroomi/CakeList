//
//  URLDataRetrieving.swift
//  Cake List
//
//  Created by Stephen Groom on 26/08/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import Foundation

protocol URLDataRetrieving {
    func retrieveData(at url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: URLDataRetrieving {
    func retrieveData(at url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = dataTask(with: url, completionHandler: completion)
        task.resume()
    }
}
