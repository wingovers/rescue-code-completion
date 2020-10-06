// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation


protocol ProjectDirectoriesRepo: Republisher {
    var liveProjectDirectories: [ProjectDirectory] { get }
    var deadProjectDirectories: [ProjectDirectory]  { get }

    func add(url: URL)
    func unwatch(id: UUID)

    func ceaseUsingSecurityScopedURLs()
}

class ProjectDirectoriesRepository: Republisher {
    private let bookmarker: SSBookmarking
    private let persistence: PersistenceCoordinating
    init(persistence: PersistenceCoordinating, bookmarker: SSBookmarking) {
        self.bookmarker = bookmarker
        self.persistence = persistence
        self.projectDirectories = persistence.loadData().projectDirectories
        super.init()
        restoreAccess()
    }

    private var projectDirectories: [ProjectDirectory] {
        didSet {
            publish()
            persistence.persist(PersistRequest(projectDirectories: projectDirectories))
        }
    }

    private func restoreAccess() {
        for index in projectDirectories.indices {
            let result = bookmarker.restoreAccess(to: projectDirectories[index].ssBookmark)
            projectDirectories[index].restoredURL = result.restoredURL
            if let validBookmark = result.bookmark {
                projectDirectories[index].ssBookmark = validBookmark
            }
        }
    }
}

extension ProjectDirectoriesRepository: ProjectDirectoriesRepo {
    var deadProjectDirectories: [ProjectDirectory] {
        return projectDirectories.filter { $0.restoredURL == nil }
    }

    var liveProjectDirectories: [ProjectDirectory] {
        projectDirectories.filter { $0.restoredURL != nil }
    }

    func add(url: URL) {
        let result = bookmarker.createBookmark(for: url)
        guard let bookmark = result.bookmark,
              let restoredURL = result.restoredURL
        else { return }
        let name = url.deletingPathExtension().lastPathComponent
        let dir = ProjectDirectory(id: UUID(),
                                   name: name,
                                   ssBookmark: bookmark,
                                   restoredURL: restoredURL)
        projectDirectories.append(dir)
    }

    func unwatch(id: UUID) {
        guard let index = projectDirectories.firstIndex(where: { $0.id == id }) else { return }
        projectDirectories.remove(at: index)
    }

    func ceaseUsingSecurityScopedURLs() {
        projectDirectories.forEach {
            guard let url = $0.restoredURL else { return }
            bookmarker.stopAccessing(url)
        }
    }
}
