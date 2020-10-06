// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

struct PreferencesButtonVM {
    let actions: WindowManagement

    let label = NSLocalizedString("preferences", comment: "button")
    let gear = Symbols.preferences.name

    func tap() {
        actions.closeMenuBarPopover()
        actions.openPreferences()
    }
}
