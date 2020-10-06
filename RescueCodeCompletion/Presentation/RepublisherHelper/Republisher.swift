// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

class Republisher: ObservableObject {
    func publish() {
        objectWillChange.send()
    }
}
