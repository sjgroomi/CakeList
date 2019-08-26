//
//  URLDataFetcher.swift
//  Cake List
//
//  Created by Stephen Groom on 26/08/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import Foundation

struct URLDataFetcher: DataFetching {
    let dataRetriever: URLDataRetrieving
    let url: URL
    
    struct UnexpectedError: Error { }
    
    func fetchData(completion: @escaping (Result<Data, Error>) -> Void) {
        dataRetriever.retrieveData(at: url) { data, response, error in
            switch (data, response, error) {
            case let (data?, _, nil):
                completion(.success(data))
            case let (_, _, error?):
                completion(.failure(error))
            default:
                completion(.failure(UnexpectedError()))
            }
        }
    }
}
