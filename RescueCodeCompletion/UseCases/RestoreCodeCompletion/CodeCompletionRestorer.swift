// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation


class CodeCompletionRestorer {
    init(opener: AppInteractor, deletor: DirectoryInteractor, preferences: PreferencesRepo) {
        self.opener = opener
        self.deletor = deletor
        self.preferences = preferences
    }
    private let opener: AppInteractor
    private let deletor: DirectoryInteractor
    private let preferences: PreferencesRepo
}

extension CodeCompletionRestorer: RestoreCodeCompletionUseCase {
    func removeDirectoryAndRestartDefaultIDE(temp id: UUID,
                                             in root: UUID,
                                             projectPath: String,
                                             completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async { [weak self] in
            self?.deletor.delete(temp: id, in: root) { didDeleteDirectory in
                guard didDeleteDirectory else {
                    completion(false)
                    return
                }

                if let shouldReopenProject = self?.preferences.reopenProject,
                   shouldReopenProject {
                    self?.conditionallyOpenDefaultIDE(with: projectPath)
                    completion(true)
                } else {
                    self?.conditionallyOpenDefaultIDE(with: "")
                    completion(true)
                }
            }
        }
    }

    private func conditionallyOpenDefaultIDE(with projectPath: String) {
        if preferences.reopenXcode {
            opener.openDefaultIDE(with: projectPath)
        }
    }
}
