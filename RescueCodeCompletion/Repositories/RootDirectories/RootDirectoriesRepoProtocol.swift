// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

protocol RootDirectoriesRepo: Republisher {
    var liveRootDirectories: [DerivedDataRootDirectory] { get }
    var deadRootDirectories: [DerivedDataRootDirectory]  { get }

    func add(url: URL)
    func alias(id: UUID, to newName: String)
    func setDefault(to id: UUID)
    func unwatch(id: UUID)
    func unlist(tempDirectory id: UUID, in root: UUID)

    func refreshTempDirectories()
    func ceaseUsingSecurityScopedURLs()
}
