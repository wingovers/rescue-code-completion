// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

class PersistenceCoordinator {
    init(local: LocalPersistence) {
        self.local = local
    }

    let local: LocalPersistence

    lazy var empty = LoadedData(rootDirectories: [DerivedDataRootDirectory](),
                                  xcodes: [Xcode](),
                                  preferences: Preferences(current: Preferences.defaults(),
                                                           menubarIcon: Preferences.defaults()),
                                  projectDirectories: [ProjectDirectory]()
    )
}

extension PersistenceCoordinator: PersistenceCoordinating {
    func loadData() -> LoadedData {
        LoadedData(rootDirectories: local.load([DerivedDataRootDirectory].self, .rootDirectories) ?? empty.rootDirectories,
                   xcodes: local.load([Xcode].self, .apps) ?? empty.xcodes,
                   preferences: local.load(Preferences.self, .preferences) ?? empty.preferences,
                   projectDirectories: local.load([ProjectDirectory].self, .projectDirectories) ?? empty.projectDirectories)
    }

    func persist(_ request: PersistRequest) {
        if let prefs = request.preferences { local.persist(prefs, .preferences) }
        if let dirs = request.rootDirectories { local.persist(dirs, .rootDirectories) }
        if let apps = request.xcodes { local.persist(apps, .apps) }
        if let projects = request.projectDirectories { local.persist(projects, .projectDirectories) }
    }
}
