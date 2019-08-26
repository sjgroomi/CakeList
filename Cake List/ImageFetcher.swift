//
//  ImageFetcher.swift
//  Cake List
//
//  Created by Stephen Groom on 26/08/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import UIKit

struct ImageFetcher {
    typealias Completion = (Result<UIImage, Error>) -> Void
    struct UnableToDownloadImageError: Error { }
    
    let urlDataRetriever: URLDataRetrieving
    
    func fetchImage(url: URL, completion: @escaping Completion) {
        urlDataRetriever.retrieveData(at: url) { data, response, error in
            switch (data, response, error) {
            case let (data?, _, nil):
                self.handleData(data, completion: completion)
            default:
                self.callCompletionWithError(completion)
            }
        }
    }
    
    private func handleData(_ data: Data, completion: Completion) {
        guard let image = UIImage(data: data) else {
            callCompletionWithError(completion)
            return
        }
        completion(.success(image))
    }
    
    private func callCompletionWithError(_ completion: Completion) {
        completion(.failure(UnableToDownloadImageError()))
    }
}
