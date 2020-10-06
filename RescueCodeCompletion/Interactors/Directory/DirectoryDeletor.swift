// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

class DirectoryDeletor {
    init(directories: RootDirectoriesRepo, preferences: PreferencesRepo) {
        self.roots = directories
        self.preferences = preferences
    }
    let roots: RootDirectoriesRepo
    let preferences: PreferencesRepo
}

extension DirectoryDeletor: DirectoryInteractor {
    func delete(temp id: UUID, in root: UUID, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().async { [weak self] in

            guard let target = self?.getTempDirectoryURL(for: id, in: root),
                  let didDelete = self?.delete(target)
            else { return }

            if didDelete { self?.roots.unlist(tempDirectory: id, in: root) }
            completion(didDelete)
        }
    }

    private func getTempDirectoryURL(for id: UUID, in root: UUID) -> URL? {
        guard let root = roots.liveRootDirectories.firstIndex(where: { $0.id == root }),
              let temp = roots.liveRootDirectories[root].tempDirectories.firstIndex(where: { $0.id == id })
        else {
                NSLog(#filePath, #function, #line, "Precondition failure")
                return nil
              }
        return roots.liveRootDirectories[root].tempDirectories[temp].url
    }

    private func delete(_ url: URL) -> Bool {
        let fm = FileManager.default
        var trashedURL: NSURL?
        do {
            if preferences.deletesPermanently {
                try fm.removeItem(at: url)
            } else {
                try fm.trashItem(at: url, resultingItemURL: &trashedURL)
            }
            return true
        }
        catch (let error) {
            NSLog(error.localizedDescription)
            return false
        }
    }
}
