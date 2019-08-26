//
//  CakeCell.swift
//  Cake List
//
//  Created by Stephen Groom on 26/08/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import UIKit

class CakeCell: UITableViewCell {
    @IBOutlet private var cakeImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    var imageFetcher: ImageFetcher?
    
    func configure(with cake: Cake) {
        fetchImage(at: cake.imageURL)
        titleLabel.text = cake.title
        descriptionLabel.text = cake.description
    }
    
    private func fetchImage(at url: URL) {
        imageFetcher = ImageFetcher(urlDataRetriever: URLSession.shared)
        imageFetcher?.fetchImage(url: url) { result in
            switch result {
            case .success(let image):
                self.updateImage(to: image)
            default:
                self.updateImage(to: nil)
            }
        }
    }
    
    private func updateImage(to image: UIImage?) {
        DispatchQueue.main.async {
            self.cakeImageView.image = image
        }
    }
}
