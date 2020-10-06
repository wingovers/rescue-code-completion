// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

protocol LocalPersistence {
    func persist<T: Encodable>(_ data: T, _ file: Filename)
    func load<T: Decodable>(_ type: T.Type, _ file: Filename) -> T?
}

enum Filename: String {
    case preferences = "Preferences"
    case rootDirectories = "Directories"
    case apps = "Apps"
    case projectDirectories = "ProjectDirectories"
}
