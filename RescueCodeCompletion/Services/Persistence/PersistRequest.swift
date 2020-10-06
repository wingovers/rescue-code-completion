// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

struct PersistRequest {
    var rootDirectories: [DerivedDataRootDirectory]? = nil
    var xcodes: [Xcode]? = nil
    var preferences: Preferences? = nil
    var projectDirectories: [ProjectDirectory]? = nil
}
