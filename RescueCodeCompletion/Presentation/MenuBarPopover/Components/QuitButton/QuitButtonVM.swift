// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import AppKit

struct QuitButtonVM {
    let label = NSLocalizedString("quit", comment: "button")
    let moon = Symbols.moon.name

    func tap() {
        NSApp.terminate(nil)
    }
}


