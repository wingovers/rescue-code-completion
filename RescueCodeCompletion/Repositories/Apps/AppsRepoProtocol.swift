// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

protocol AppsRepo: Republisher {
    var liveXcodeApps: [Xcode]  { get }
    var deadXcodeApps: [Xcode]  { get }
    func add(app url: URL)
    func unwatch(id: UUID)
    func alias(id: UUID, to newName: String)
    func setDefault(to id: UUID)
    func ceaseUsingSecurityScopedURLs()
}
