// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

class RootDirectorySectionVM: VM {
    init(root: DerivedDataRootDirectory,
         dirs: RootDirectoriesRepo,
         prefs: PreferencesRepo) {
        self.root = root
        self.dirs = dirs
        self.prefs = prefs
        super.init(subscribe: dirs, prefs)
    }
    @Published private var root: DerivedDataRootDirectory
    @Published private var dirs: RootDirectoriesRepo
    @Published private var prefs: PreferencesRepo

    var id: UUID { root.id }
    var name: String { root.name }
    var showSectionNames: Bool {
        dirs.liveRootDirectories.count > 1
        && name != NSLocalizedString("default", comment: "directory category")
    }

    var todaysTempDirectories: [DerivedDataTempDirectory] {
        let calendar = Calendar.current
        return root.tempDirectories
            .filter { calendar.isDateInToday($0.updated) }
            .sorted { (first, second) -> Bool in
                first.updated > second.updated
            }
    }

    private var shoulShowOlderDirectories: Bool {
        !prefs.showRecentsOnly
    }

    var showOlderDirectories: Bool {
        shoulShowOlderDirectories &&
        olderTempDirectories.count > 0
    }

    let olderTempDirectoriesLabel = NSLocalizedString("older", comment: "subhead")
    var olderTempDirectories: [DerivedDataTempDirectory] {
        let calendar = Calendar.current
        return root.tempDirectories
            .filter {!calendar.isDateInToday($0.updated) }
            .sorted { $0.updated > $1.updated }
    }

    let directoriesExpansionIcon = Symbols.chevronRight.name
}
