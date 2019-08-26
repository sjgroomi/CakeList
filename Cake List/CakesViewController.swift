//
//  CakesViewController.swift
//  Cake List
//
//  Created by Stephen Groom on 26/08/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import UIKit

class CakesViewController: UITableViewController {
    
    let cakeRetriever: CakeRetriever = {
        guard let cakesURL = URL(string: "https://gist.githubusercontent.com/hart88/198f29ec5114a3ec3460/raw/8dd19a88f9b8d24c23d9960f3300d0c917a4f07c/cake.json") else {
            fatalError("Invalid Cakes URL")
        }
        let urlDataFetcher = URLDataFetcher(dataRetriever: URLSession.shared,
                                            url: cakesURL)
        return CakeRetriever(dataFetcher: urlDataFetcher)
    }()
    
    var dataSource: UITableViewDataSource? {
        didSet {
            tableView.dataSource = dataSource
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        retrieveCakes()
    }
    
    private func configureTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 89
    }
    
    private func retrieveCakes() {
        cakeRetriever.retrieveCakes { result in
            switch result {
            case .success(let cakes):
                self.handleCakes(cakes)
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    private func handleCakes(_ cakes: [Cake]) {
        DispatchQueue.main.async {
            self.dataSource = GenericTableViewDataSource(items: cakes,
                                                         cellConfigurator: self.configureCell)
        }
    }
    
    private func configureCell(at indexPath: IndexPath, cake: Cake) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CakeCell", for: indexPath) as? CakeCell else {
            fatalError("Unable to dequeue cake cell")
        }
        cell.configure(with: cake)
        return cell
    }
    
    private func handleError(_ error: Error) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Retry",
                                                style: .default,
                                                handler: { _ in
                                                    self.retrieveCakes()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel",
                                                style: .cancel,
                                                handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
