// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation
import SwiftUI
import AppKit

class MenuBarPopoverVM: VM {
    init(apps: AppsRepo, dirs: RootDirectoriesRepo) {
        self.appsRepo = apps
        self.dirsRepo = dirs
        super.init(subscribe: apps, dirs)
    }

    private let appsRepo: AppsRepo
    private let dirsRepo: RootDirectoriesRepo
}

// MARK: - MODEL ACCESS
extension MenuBarPopoverVM {
    var rootDirectories: [DerivedDataRootDirectory] {
        var dirs = dirsRepo.liveRootDirectories
            .sorted { $0.tempDirectories.count < $1.tempDirectories.count }
        guard let index = dirs.firstIndex(where: { $0.isDefault }) else { return dirs }
        dirs.swapAt(0, index)
        return dirs
    }
    var apps: [Xcode] {
        appsRepo.liveXcodeApps.sorted { $0.name < $1.name }
    }

    var showOnboarding: Bool {
        rootDirectories.isEmpty && apps.isEmpty
    }
}

// MARK: - INTENTS
extension MenuBarPopoverVM {
    func setDefault(Xcode id: UUID) {
        appsRepo.setDefault(to: id)
    }
}

