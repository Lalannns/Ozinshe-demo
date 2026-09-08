//
//  URLs.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 16.08.2026.
//

import Foundation

class URLs {
    static let BASE_URL = "https://apiozinshe.mobydev.kz/core/V1/"
    
    // AUTH ENDPOINTS
    static let SIGN_IN_URL = "https://apiozinshe.mobydev.kz/auth/V1/signin"
    static let SIGN_UP_URL = "https://apiozinshe.mobydev.kz/auth/V1/signup"
    
    // CORE ENDPOINTS
    static let FAVORITES_URL = BASE_URL + "favorite/"
    static let ADD_FAVORITES_URL = BASE_URL + "favorite"
    static let DELETE_FAVORITES_URL = BASE_URL + "favorite/has-like"
    static let CATEGORIES_URL = BASE_URL + "categories"
    static let SEARCH_MOVIES_URL = BASE_URL + "movies/search"
    static let MOVIES_BY_CATEGORY_URL = BASE_URL + "movies/page"
    static let MAIN_MOVIES_URL = BASE_URL + "movies/main"
    static let GENRES_URL = BASE_URL + "genres"
    static let CATEGORY_AGES_URL = BASE_URL + "category-ages"
    static let MAIN_BANNERS_URL = BASE_URL + "movies_main"
    static let HISTORY_URL = BASE_URL + "history/userHistory"
    
    // DETAIL ENDPOINTS
    static let MOVIE_DETAIL_URL = BASE_URL + "movies/"
    static let SCREENSHOTS_URL = BASE_URL + "screenshots/"
    static let SIMILAR_MOVIES_URL = BASE_URL + "movies/similar/"
    static let GET_SEASONS_URL = BASE_URL + "seasons/"
}
