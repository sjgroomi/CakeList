//
//  DataFetching.swift
//  Cake List
//
//  Created by Stephen Groom on 26/08/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import Foundation

protocol DataFetching {
    func fetchData(completion: (Result<Data, Error>) -> Void)
}
