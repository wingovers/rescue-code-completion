// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

protocol DirectoryInteractor {
    func delete(temp id: UUID, in root: UUID, completion: @escaping (Bool) -> Void)
}
