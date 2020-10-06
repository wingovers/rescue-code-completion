// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

protocol RestoreCodeCompletionUseCase {
    func removeDirectoryAndRestartDefaultIDE(temp id: UUID, in root: UUID, projectPath: String, completion: @escaping (Bool) -> Void)
}
