// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

struct NoFoldersTestBattery: Battery {
    let name = "EmptyMockDerivedData"
    let tempDirectories: [TempDir] = [TempDir]()
}
