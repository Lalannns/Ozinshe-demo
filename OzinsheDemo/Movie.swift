//
//  Movie.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 16.08.2026.
//

import Foundation

nonisolated struct SearchResponse: Codable, Sendable {
    let content: [Movie]?
}

nonisolated struct Movie: Codable, Sendable {
    let id: Int
    let name: String?          // Backend sends 'name'
    let title: String?         // Fallback field
    let keyWords: String?
    let description: String?
    let year: Int?
    let trend: Bool?
    let favorite: Bool?
    let movieType: String?
    let poster: Poster?
    let categories: [Category]?
    let genres: [Category]?
    let categoryAges: [Category]?
    
    // Derived property for title
    var displayTitle: String {
        if let name = name, !name.isEmpty { return name }
        if let title = title, !title.isEmpty { return title }
        return "Без названия"
    }
    
    // Derived property for categories/genres text
    var displaySubcategories: String {
        var list: [String] = []
        
        if let categories = categories, !categories.isEmpty {
            list.append(contentsOf: categories.map { $0.name })
        } else if let genres = genres, !genres.isEmpty {
            list.append(contentsOf: genres.map { $0.name })
        } else if let categoryAges = categoryAges, !categoryAges.isEmpty {
            list.append(contentsOf: categoryAges.map { $0.name })
        }
        
        return list.joined(separator: " • ")
    }
    
    nonisolated struct Poster: Codable, Sendable {
        let id: Int?
        let fileId: Int?
        let link: String?
        let movieId: Int?
    }
    
    nonisolated struct Category: Codable, Sendable {
        let id: Int
        let name: String
        let link: String?
        let fileId: Int?
        let movieCount: Int?
    }
}
