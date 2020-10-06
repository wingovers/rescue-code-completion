// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

protocol PreferencesRepo: Republisher {
    var deletesPermanently: Bool { get }
    var menubarIcon: MenubarIcon { get }
    var menubarIconUpdates: Published<MenubarIcon>.Publisher { get }
    var reopenXcode: Bool { get }
    var reopenProject: Bool { get }
    var showRecentsOnly: Bool { get }
    var startsAtLogin: Bool { get }

    func setMenubarIcon(to icon: MenubarIcon)
    func setShouldOpenDefaultIDEAfterDelete(to state: Bool)
    func setShouldOpenProjectAfterDelete(to state: Bool)
    func setShouldDeletePermanently(to state: Bool)
    func setShowRecentsOnly(to state: Bool)
    func setStartsAtLogin(to state: Bool)
}
