// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation
import AppKit

class AppsRepository: Republisher {
    private let persistence: PersistenceCoordinating
    private let bookmarker: SSBookmarking
    init(persistence: PersistenceCoordinating, bookmarker: SSBookmarking) {
        self.Xcodes = persistence.loadData().xcodes
        self.bookmarker = bookmarker
        self.persistence = persistence
        super.init()
        restoreAppLinksAndMetadata()
    }

    private var Xcodes: [Xcode] {
        didSet {
            publish()
            persistence.persist(PersistRequest(xcodes: Xcodes))
        }
    }
}

extension AppsRepository: AppsRepo {
    var liveXcodeApps: [Xcode] {
        Xcodes.filter { $0.restoredURL != nil }
    }

    var deadXcodeApps: [Xcode] {
        return Xcodes.filter { $0.restoredURL == nil }
    }

    func add(app url: URL) {
        let result = bookmarker.createBookmark(for: url)
        guard let name = result.restoredURL?.deletingPathExtension().lastPathComponent,
              let bookmark = result.bookmark,
              let icon = getAppIcon(from: url)
        else { return }
        let isFirstApp = liveXcodeApps.count == 0

        var app = Xcode(id: UUID(),
                        name: name,
                        ssBookmark: bookmark,
                        restoredURL: url,
                        isDefault: isFirstApp)
        app.tempSetImage(icon)
        Xcodes.append(app)
    }

    func unwatch(id: UUID) {
        guard let index = Xcodes.firstIndex(where: { $0.id == id }) else { return }
        Xcodes.remove(at: index)
    }

    func alias(id: UUID, to newName: String) {
        guard let index = Xcodes.firstIndex(where: { $0.id == id }) else { return }
        Xcodes[index].name = newName
    }

    func setDefault(to id: UUID) {
        for index in Xcodes.indices {
            Xcodes[index].isDefault = false
        }
        guard let targetIndex = Xcodes.firstIndex(where: { $0.id == id }) else { return }
        Xcodes[targetIndex].isDefault = true
    }

    func ceaseUsingSecurityScopedURLs() {
        Xcodes.forEach {
            guard let url = $0.restoredURL else { return }
            bookmarker.stopAccessing(url)
        }
    }
}

private extension AppsRepository {

    func restoreAppLinksAndMetadata() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.restoreAccessToSSBookmarks { [weak self] in
                self?.repopulateAppIcons()
            }
        }
    }

    func restoreAccessToSSBookmarks(completion: @escaping () -> Void) {
        Xcodes.enumerated().forEach {
            let result = bookmarker.restoreAccess(to: $0.element.ssBookmark)
            Xcodes[$0.offset].restoredURL = result.restoredURL
            if let validBookmark = result.bookmark {
                Xcodes[$0.offset].ssBookmark = validBookmark
            }
            if $0.offset == (Xcodes.count - 1) { completion() }
        }
    }

    func repopulateAppIcons() {
        Xcodes.enumerated().forEach {
            guard let validURL = $0.element.restoredURL,
                  let image = getAppIcon(from: validURL)
            else { return }
            Xcodes[$0.offset].tempSetImage(image)
        }
    }

    func getAppIcon(from app: URL) -> NSImage? {
        let keys: Set<URLResourceKey> = [
            .isApplicationKey,
            .effectiveIconKey
        ]
        guard let details = try? app.resourceValues(forKeys: keys),
              let isApp = details.isApplication,
              isApp,
              let icon = details.effectiveIcon as? NSImage,
              icon.isValid
        else { return nil }
        return icon
    }
}
