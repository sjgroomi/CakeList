//
//  GenericTableViewDataSource.swift
//  Cake List
//
//  Created by Stephen Groom on 26/08/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import UIKit

class GenericTableViewDataSource<T>: NSObject, UITableViewDataSource {
    
    typealias CellConfigurator = (IndexPath, T) -> UITableViewCell
    
    private let items: [T]
    private let cellConfigurator: CellConfigurator
    
    init(items: [T], cellConfigurator: @escaping CellConfigurator) {
        self.items = items
        self.cellConfigurator = cellConfigurator
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellConfigurator(indexPath, items[indexPath.row])
    }
}

