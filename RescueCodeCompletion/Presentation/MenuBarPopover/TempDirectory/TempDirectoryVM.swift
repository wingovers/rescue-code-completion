// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

class TempDirectoryVM: VM {
    init(dir: DerivedDataTempDirectory,
         root: UUID,
         repo: RootDirectoriesRepo,
         restorer: RestoreCodeCompletionUseCase) {
        self.dir = dir
        self.root = root
        self.repo = repo
        self.restorer = restorer
        super.init(subscribe: repo)
    }

    let restorer: RestoreCodeCompletionUseCase
    @Published private var dir: DerivedDataTempDirectory
    @Published private var repo: RootDirectoriesRepo
    private var root: UUID

    var name: String { dir.name }

    var hasError: Bool {
        repo.deadRootDirectories
            .map { $0.tempDirectories.contains(dir)}
            .contains(true)
    }

    var directorySymbol: String {
        hasError
            ? Symbols.directoryError.name
            : Symbols.directoryDelete.name
    }

    @Published var shouldExist = true
}

// MARK: - Intents
extension TempDirectoryVM {
    func eradicate() {
        restorer.removeDirectoryAndRestartDefaultIDE(temp: dir.id,
                                                     in: root,
                                                     projectPath: dir.xcodeprojPath)
        { didEradicate in
            DispatchQueue.main.async { [weak self] in
                self?.shouldExist = false
            }
        }
    }
}
