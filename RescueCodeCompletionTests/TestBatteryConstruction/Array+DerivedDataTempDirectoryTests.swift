// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation
@testable import Rescue_Code_Completion

extension Array where Element == DerivedDataTempDirectory {
    mutating func sortAlphaForReadoutPurposes() {
        self.sort { (left, right) in
            left.url.path < right.url.path
        }
    }
}
