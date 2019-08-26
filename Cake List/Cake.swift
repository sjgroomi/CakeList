//
//  Cake.swift
//  Cake List
//
//  Created by Stephen Groom on 26/08/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import Foundation

struct Cake: Decodable {
    enum CodingKeys: String, CodingKey {
        case title
        case description = "desc"
        case imageURL = "image"
    }
    let title: String
    let description: String
    let imageURL: URL
}
