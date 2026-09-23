//
//  URLs.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 16.08.2026.
//

import Foundation

class URLs {
    static let BASE_URL = "https://apiozinshe.mobydev.kz/core/V1/"
    
    // Auth
    static let SIGN_IN_URL = BASE_URL + "auth/V1/signin"
    static let SIGN_UP_URL = BASE_URL + "auth/V1/signup"
    
    // Feed, Search & Categories
    static let MAIN_MOVIES_URL = BASE_URL + "movies/main"
    static let GENRES_URL = BASE_URL + "genres"
    static let CATEGORIES_URL = BASE_URL + "categories"
    static let SEARCH_MOVIES_URL = BASE_URL + "movies/search"
    static let MOVIES_BY_CATEGORY_URL = BASE_URL + "movies"
    
    // Favorites
    static let FAVORITES_URL = BASE_URL + "favorite/"        // GET  (Fetch list)
    static let ADD_FAVORITES_URL = BASE_URL + "favorite"      // POST (Add)
    static let DELETE_FAVORITES_URL = BASE_URL + "favorite/"   // DELETE (Remove)
    
    // User Profile
    static let USER_PROFILE_URL = BASE_URL + "user/profile"
    static let CHANGE_PASSWORD_URL = BASE_URL + "user/profile/change-password"
    
    //MovieDetail
    static let MOVIE_DETAIL_URL = BASE_URL + "movies/"
    static let SCREENSHOTS_URL = BASE_URL + "screenshots/"
    static let SIMILAR_MOVIES_URL = BASE_URL + "movies/similar/"
    
}

extension String {
    var fixedURL: URL? {
        let correctedString = self.replacingOccurrences(
            of: "http://api.ozinshe.com",
            with: "https://apiozinshe.mobydev.kz"
        )
        guard let encodedString = correctedString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        return URL(string: encodedString)
    }
}
