// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

protocol Battery {
    var name: String { get }
    var tempDirectories: [TempDir] { get }
}
