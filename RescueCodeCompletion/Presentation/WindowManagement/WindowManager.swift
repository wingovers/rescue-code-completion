// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

class WindowManager: WindowManagement {
    var popoverClose: Actions.MenuBarPopoverClose?
    var preferencesOpen: Actions.OpenPreferencesPanel?
    var preferencesClose: Actions.ClosePreferencesPanel?

    func set(action: Actions) {
        switch action {
        case .menuBarPopoverClose(let closure):
            popoverClose = closure
        case .preferencesClose(let closure):
            preferencesClose = closure
        case .preferencesOpen(let closure):
            preferencesOpen = closure
        }
    }

    func closeMenuBarPopover() {
        guard let closePopover = popoverClose else { return }
        closePopover(nil)
    }

    func openPreferences() {
        guard let openPreferences = preferencesOpen else { return }
        openPreferences()
    }

    func closePreferences() {
        guard let closePreferences = preferencesClose else { return }
        closePreferences()
    }
}
