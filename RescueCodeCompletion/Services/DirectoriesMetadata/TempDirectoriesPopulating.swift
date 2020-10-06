// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

protocol TempDirectoriesPopulating {
    func populateTemps(in root: URL) -> [DerivedDataTempDirectory]
}
