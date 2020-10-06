// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import AppKit

class IDEButtonVM: VM {
    init(apps: AppsRepo, app: Xcode) {
        self.apps = apps
        self.app = app
        super.init(subscribe: apps)
    }
    @Published private var apps: AppsRepo
    @Published private var app: Xcode

    var name: String {
        app.name
    }

    var isDefault: Bool {
        app.isDefault
    }

    var icon: NSImage? {
        app.icon
    }

    var showIcon: Bool {
        icon != nil
    }

    let substituteIconSymbol = Symbols.appSubstituteIcon.name
}
