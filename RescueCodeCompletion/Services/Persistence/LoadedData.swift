// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

struct LoadedData: Codable {
    var rootDirectories: [DerivedDataRootDirectory]
    var xcodes: [Xcode]
    var preferences: Preferences
    var projectDirectories: [ProjectDirectory]
}
