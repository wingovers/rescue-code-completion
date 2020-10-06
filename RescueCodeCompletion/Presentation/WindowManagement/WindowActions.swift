// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

enum Actions {
    case menuBarPopoverClose(MenuBarPopoverClose)
    case preferencesClose(OpenPreferencesPanel)
    case preferencesOpen(ClosePreferencesPanel)

    typealias MenuBarPopoverClose = (Any?) -> Void
    typealias OpenPreferencesPanel = () -> Void
    typealias ClosePreferencesPanel = () -> Void
}
