// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

struct FourFolderTestBattery: Battery {
    let name = "MockDerivedData"
    let tempDirectories: [TempDir] =
        [
            tempDir1,
            tempDir2,
            tempDir3,
            tempDir4
        ]

    static let tempDir1 = TempDir(test: "Test1",
                                  plist: .valid)
    static let tempDir2 = TempDir(test: "Test2",
                                  plist: .invalidKey)
    static let tempDir3 = TempDir(test: "Test3",
                                  plist: .invalidPathExtension)
    static let tempDir4 = TempDir(test: "Test4",
                                  plist: .absent)

}

