// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation
@testable import Rescue_Code_Completion

typealias Deletes = (temp: UUID, root: UUID)
class StubbedDirectoryInteractor: DirectoryInteractor {
    var deletes = [Deletes]()

    func delete(temp id: UUID, in root: UUID, completion: @escaping (Bool) -> Void) {
        deletes.append((id, root))
        completion(true)
    }
}
