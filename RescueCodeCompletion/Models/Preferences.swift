// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

struct Preferences {
    var current: [Preference:Bool]
    var menubarIcon: MenubarIcon

    func getCurrentOrDefault(for preference: Preference) -> Bool {
        current[preference] ?? preference.defaultSetting
    }
}

extension Preferences {
    enum Preference: String, Codable, CaseIterable {
        case showRecentsOnly = "showRecentsOnly"
        case deletesPermanently = "deletedPermanently"
        case reopenXcode = "reopenXcode"
        case reopenProject = "reopenProject"
        case startsAtLogin = "startsAtLogin"

        var defaultSetting: Bool {
            switch self {
                case .deletesPermanently: return true
                case .showRecentsOnly: return true
                case .reopenXcode: return true
                case .reopenProject: return true
                case .startsAtLogin: return false
            }
        }
    }
}

extension Preferences {
    static func defaults() -> [Preference:Bool] {
        var defaults = [Preference:Bool]()
        Preference.allCases.forEach {
            defaults[$0] = $0.defaultSetting
        }
        return defaults
    }
    static func defaults() -> MenubarIcon {
        .filledLight
    }
}

extension Preferences: Codable {}
