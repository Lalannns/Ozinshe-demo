//
//  Movie.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 16.08.2026.
//

import Foundation
import SwiftyJSON

struct Movie {
    let id: Int
    let name: String
    let year: Int
    let posterUrl: String
    let categories: [String]
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.year = json["year"].intValue
        self.posterUrl = json["poster"]["link"].stringValue
        self.categories = json["categories"].arrayValue.map { $0["name"].stringValue }
    }
}
