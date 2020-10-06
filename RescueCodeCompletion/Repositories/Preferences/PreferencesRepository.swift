// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

class PreferencesRepository: Republisher {
    private let persistence: PersistenceCoordinating
    init(persistence: PersistenceCoordinating) {
        self.persistence = persistence
        self.preferences = persistence.loadData().preferences
        self.menubarIcon = preferences.menubarIcon
        super.init()
    }

    private var preferences: Preferences {
        didSet {
            publish()
            persistence.persist(PersistRequest(preferences: preferences))
        }
    }

    @Published private(set) var menubarIcon: MenubarIcon
}

extension PreferencesRepository: PreferencesRepo {


    var menubarIconUpdates: Published<MenubarIcon>.Publisher {
        $menubarIcon
    }

    var deletesPermanently: Bool {
        preferences.getCurrentOrDefault(for: .deletesPermanently)
    }

    var reopenProject: Bool {
        preferences.getCurrentOrDefault(for: .reopenProject)
    }

    var reopenXcode: Bool {
        preferences.getCurrentOrDefault(for: .reopenXcode)
    }

    var showRecentsOnly: Bool {
        preferences.getCurrentOrDefault(for: .showRecentsOnly)
    }

    var startsAtLogin: Bool {
        preferences.getCurrentOrDefault(for: .startsAtLogin)
    }

    func setStartsAtLogin(to state: Bool) {
        preferences.current[.startsAtLogin] = state
    }

    func setMenubarIcon(to icon: MenubarIcon) {
        preferences.menubarIcon = icon
        menubarIcon = icon
    }

    func setShouldOpenProjectAfterDelete(to state: Bool) {
        preferences.current[.reopenProject] = state
    }

    func setShouldOpenDefaultIDEAfterDelete(to state: Bool) {
        preferences.current[.reopenXcode] = state
    }

    func setShouldDeletePermanently(to state: Bool) {
        preferences.current[.deletesPermanently] = state
    }

    func setShowRecentsOnly(to state: Bool) {
        preferences.current[.showRecentsOnly] = state
    }
}
