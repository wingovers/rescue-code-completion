// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

protocol WindowManagement {
    func set(action: Actions)

    func closeMenuBarPopover()
    func openPreferences()
    func closePreferences()
}
