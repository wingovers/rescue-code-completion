// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

protocol SSBookmarking {
    func createBookmark(for url: URL) -> SSBookmark
    func restoreAccess(to bookmark: Data) -> SSBookmark
    func stopAccessing(_ url: URL)
}

struct SSBookmarker: SSBookmarking {
    func createBookmark(for url: URL) -> SSBookmark {
        guard let bookmark = try? url.bookmarkData(options: .withSecurityScope,
                                                   includingResourceValuesForKeys: nil,
                                                   relativeTo: nil)
        else { return SSBookmark(bookmark: nil, restoredURL: nil) }
        return SSBookmark(bookmark: bookmark, restoredURL: url)
    }

    func restoreAccess(to bookmark: Data) -> SSBookmark {
        var isStale = false
        guard let url = try? URL(resolvingBookmarkData: bookmark,
                                 options: .withSecurityScope,
                                 relativeTo: nil,
                                 bookmarkDataIsStale: &isStale),
              url.startAccessingSecurityScopedResource()
        else { return SSBookmark(bookmark: nil, restoredURL: nil) }
        guard !isStale else { return createBookmark(for: url) }
        return SSBookmark(bookmark: bookmark, restoredURL: url)
    }

    func stopAccessing(_ url: URL) {
        url.stopAccessingSecurityScopedResource()
    }
}

struct SSBookmark {
    let bookmark: Data?
    let restoredURL: URL?
}
