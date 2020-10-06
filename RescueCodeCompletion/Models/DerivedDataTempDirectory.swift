// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

struct DerivedDataTempDirectory: Identifiable, Hashable {
    var id: UUID
    var url: URL
    var name: String
    var updated: Date
    var xcodeprojPath: String
}

