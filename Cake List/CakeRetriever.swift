//
//  CakeRetriever.swift
//  Cake List
//
//  Created by Stephen Groom on 26/08/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import Foundation

struct CakeRetriever {
    typealias Completion = (Result<[Cake], Error>) -> Void
    let dataFetcher: DataFetching
    
    func retrieveCakes(completion: @escaping Completion) {
        dataFetcher.fetchData { result in
            switch result {
            case .success(let data):
                parseCakeData(data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func parseCakeData(_ data: Data, completion: Completion) {
        let decoder = JSONDecoder()
        do {
            let cakes = try decoder.decode([Cake].self, from: data)
            completion(.success(cakes))
        } catch {
            completion(.failure(error))
        }
    }
}
