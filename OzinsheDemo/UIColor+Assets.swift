//
//  UIColor+Assets.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 25.08.2026.
//

import Foundation
import UIKit

extension UIColor {
    // Dynamic Theme Colors
    static let appBackground = UIColor(named: "Background") ?? .white
    static let appTextColor = UIColor(named: "111827") ?? .label
    
    // Additional Hex/Card Colors from Assets
    static let appCardBackground = UIColor(named: "1C2431") ?? .secondarySystemBackground
    static let appPrimary = UIColor(named: "9753F0") ?? .systemPurple
}

