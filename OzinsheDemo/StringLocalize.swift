//
//  StringLocalize.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 25.07.2026.
//

import Foundation

extension String {
    func localized() -> String {
        let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "Қазақша"
        
        let languageCode: String
        switch savedLanguage {
        case "English": languageCode = "en"
        case "Русский": languageCode = "ru"
        default: languageCode = "kk"
        }
        
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(self, comment: "")
        }
        
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
