//
//  Movie.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 16.08.2026.
//

nonisolated struct Movie: Codable, Sendable {
    let id: Int
    let movieNumber: Int?
    let title: String?
    let keyWords: String?
    let description: String?
    let year: Int?
    let trend: Bool?
    let poster: Poster?
    let categories: [Category]?
    
    nonisolated struct Poster: Codable, Sendable {
        let id: Int
        let link: String
    }
    
    nonisolated struct Category: Codable, Sendable {
        let id: Int
        let name: String
        let link: String?
        let fileId: Int?
        let movieCount: Int?
    }
}
