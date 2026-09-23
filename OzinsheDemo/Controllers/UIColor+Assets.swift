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
    static let appBackground = UIColor(named: "Background") ?? UIColor(red: 17/255, green: 24/255, blue: 39/255, alpha: 1.0)
    static let appTextColor = UIColor(named: "111827") ?? .label
    
    // Additional Hex/Card Colors from Assets
    static let appCardBackground = UIColor(named: "1C2431") ?? UIColor(red: 28/255, green: 36/255, blue: 49/255, alpha: 1.0)
    static let appPrimary = UIColor(named: "9753F0") ?? .systemPurple
}
