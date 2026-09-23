//
//  MainModels.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 23.09.2026.
//

import Foundation

// MARK: - Banner Model
nonisolated struct Banner: Codable, Sendable {
    let id: Int
    let link: String?
    let title: String?
    let summary: String?
    let movie: Movie?
}

// MARK: - MainMovies Model
nonisolated struct MainMovies: Codable, Sendable {
    let id: Int?             // Сделайте опциональным
    let categoryId: Int?
    let categoryName: String?
    let movies: [Movie]?
    
    // Удобный свойство-фолбэк для получения ID категории
    var validCategoryId: Int {
        return categoryId ?? id ?? 0
    }
}

// MARK: - Genre Model
nonisolated struct Genre: Codable, Sendable {
    let id: Int
    let name: String
    let link: String?
    let fileId: Int?
    let movieCount: Int?
}

// MARK: - AgeCategory Model
nonisolated struct AgeCategory: Codable, Sendable {
    let id: Int
    let name: String
    let link: String?
    let fileId: Int?
    let movieCount: Int?
}
