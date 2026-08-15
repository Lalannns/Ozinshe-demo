//
//  Storage.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 16.08.2026.
//

import Foundation
import UIKit

class Storage {
    public var accessToken: String = ""
    public var avatarImage: Data = Data()
    public var themeKey: String = ""
    
    static let sharedInstance = Storage()
}
