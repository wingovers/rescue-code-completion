// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

enum Symbols: String {

    case close = "xmark"
    case cursor = "cursorarrow"
    case bolt = "bolt.fill"

    case directoryDelete = "trash.fill"
    case chevronRight = "chevron.right"
    case directoryError = "exclamationmark.triangle.fill"

    case appSubstituteIcon = "hammer.fill"
    case preferences = "gearshape.fill"
    case moon = "moon.fill"

    case directoryAdd = "plus"
    case directoryRemove = "minus"
    case pinned = "pin.fill"
    case unpinned = "pin"

    case helpOn = "questionmark.circle.fill"
    case helpOff = "questionmark.circle"
    case feedbackOff = "envelope"
    case feedbackOn = "envelope.fill"
    case githubOn  = "exclamationmark.bubble.fill"
    case githubOff  = "exclamationmark.bubble"

    var name: String { self.rawValue }
}
