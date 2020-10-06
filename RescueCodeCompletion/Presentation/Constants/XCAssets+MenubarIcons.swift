//
//  XCAssets+MenubarIcons.swift
 
//
//  Created by Ryan on 10/27/20.
//

import Foundation

enum MenubarIcon: String, Codable, CaseIterable, Identifiable {
    case filled = "StatusBarIconFilled"
    case swift = "StatusBarIconSwift"
    case filledLight = "StatusBarIconFilledLight"
    case swiftLight = "StatusBarIconSwiftLight"

    var xcasset: String { self.rawValue }
    var id: String { self.rawValue }
}
