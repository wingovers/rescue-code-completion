// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation
@testable import Rescue_Code_Completion

typealias PreferenceChanges = (Preferences.Preference, newState: Bool)
class StubbedPreferencesRepo: Republisher, PreferencesRepo {
    var changesToPreferencesMade = [PreferenceChanges]()
    var changesToIconsMade = [MenubarIcon]()

    var deletesPermanently = true
    var reopenXcode = true
    var reopenProject = true
    var showRecentsOnly = true
    var startsAtLogin: Bool = false
    @Published private(set) var menubarIcon: MenubarIcon = .filledLight
    var menubarIconUpdates: Published<MenubarIcon>.Publisher { $menubarIcon }

    func setMenubarIcon(to icon: MenubarIcon) {
        menubarIcon = icon
        changesToIconsMade.append(icon)
    }

    func setShouldOpenDefaultIDEAfterDelete(to state: Bool) {
        reopenXcode = state
        changesToPreferencesMade.append((.reopenXcode, state))
    }

    func setShouldOpenProjectAfterDelete(to state: Bool) {
        reopenProject = state
        changesToPreferencesMade.append((.reopenProject, state))
    }

    func setShouldDeletePermanently(to state: Bool) {
        deletesPermanently = state
        changesToPreferencesMade.append((.deletesPermanently, state))
    }

    func setShowRecentsOnly(to state: Bool) {
        showRecentsOnly = state
        changesToPreferencesMade.append((.showRecentsOnly, state))
    }

    func setStartsAtLogin(to state: Bool) {
        startsAtLogin = state
        changesToPreferencesMade.append((.startsAtLogin, state))
    }
}
