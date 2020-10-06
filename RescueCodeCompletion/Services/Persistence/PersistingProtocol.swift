// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

protocol PersistenceCoordinating {
    func persist(_ request: PersistRequest)
    func loadData() -> LoadedData
}
