// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

class RootDirectoriesRepository: Republisher {
    private let bookmarker: SSBookmarking
    private let persistence: PersistenceCoordinating
    private let tempPopulator: TempDirectoriesPopulating
    init(persistence: PersistenceCoordinating, bookmarker: SSBookmarking, tempPopulator: TempDirectoriesPopulating) {
        self.bookmarker = bookmarker
        self.persistence = persistence
        self.rootDirectories = persistence.loadData().rootDirectories
        self.tempPopulator = tempPopulator
        super.init()
        restoreAccessAndPopulateTempDirectories()
    }

    private var rootDirectories: [DerivedDataRootDirectory] {
        didSet {
            publish()
            persistence.persist(PersistRequest(rootDirectories: rootDirectories))
        }
    }
}

extension RootDirectoriesRepository: RootDirectoriesRepo {
    var liveRootDirectories: [DerivedDataRootDirectory] {
        rootDirectories.filter { $0.restoredURL != nil }
    }

    var deadRootDirectories: [DerivedDataRootDirectory] {
        return rootDirectories.filter { $0.restoredURL == nil }
    }

    func add(url: URL) {
        let result = bookmarker.createBookmark(for: url)
        guard let bookmark = result.bookmark,
            let restoredURL = result.restoredURL
        else { return }
        let isFirstDirectory = liveRootDirectories.count == 0
        let name = url.deletingPathExtension().lastPathComponent
        let contents = tempPopulator.populateTemps(in: restoredURL)
        let dir = DerivedDataRootDirectory(id: UUID(),
                                           name: name,
                                           ssBookmark: bookmark,
                                           restoredURL: restoredURL,
                                           tempDirectories: contents,
                                           isDefault: isFirstDirectory)
        rootDirectories.append(dir)
    }

    func alias(id: UUID, to newName: String) {
        guard let index = rootDirectories.firstIndex(where: { $0.id == id }) else { return }
        rootDirectories[index].name = newName
    }

    func setDefault(to id: UUID) {
        for index in rootDirectories.indices {
            rootDirectories[index].isDefault = false
        }
        guard let targetIndex = rootDirectories.firstIndex(where: { $0.id == id }) else { return }
        rootDirectories[targetIndex].isDefault = true
    }

    func unwatch(id: UUID) {
        guard let index = rootDirectories.firstIndex(where: { $0.id == id }) else { return }
        rootDirectories.remove(at: index)
    }

    func unlist(tempDirectory tempID: UUID, in rootID: UUID) {
        guard let rootIndex = rootDirectories.firstIndex(where: { $0.id == rootID }),
              let tempIndex = rootDirectories[rootIndex].tempDirectories.firstIndex(where: { $0.id == tempID })
        else { return }
        rootDirectories[rootIndex].tempDirectories.remove(at: tempIndex)
    }

    func refreshTempDirectories() {
        populateAllRootDirectoriesTempDirectories()
    }

    func ceaseUsingSecurityScopedURLs() {
        rootDirectories.forEach {
            guard let url = $0.restoredURL else { return }
            bookmarker.stopAccessing(url)
        }
    }
}

private extension RootDirectoriesRepository {

    func restoreAccessAndPopulateTempDirectories() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.restoreAccessToSSBookmarks { [weak self] in
                self?.populateAllRootDirectoriesTempDirectories()
            }
        }
    }

    func restoreAccessToSSBookmarks(completion: @escaping () -> Void) {
        for index in rootDirectories.indices {
            let result = bookmarker.restoreAccess(to: rootDirectories[index].ssBookmark)
            rootDirectories[index].restoredURL = result.restoredURL
            if let validBookmark = result.bookmark {
                rootDirectories[index].ssBookmark = validBookmark
            }
            if index == rootDirectories.count - 1 {
                completion()
            }
        }
    }

    func populateAllRootDirectoriesTempDirectories() {
        for index in rootDirectories.indices {
            guard let url = rootDirectories[index].restoredURL else { continue }
            rootDirectories[index].tempDirectories = tempPopulator.populateTemps(in: url)
        }
    }
}

