// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation


struct FileManagerDirectoryContentsResult {
    var keys: Set<URLResourceKey>
    var urls: [URL]
}

struct FileManagerAppContentsResult {
    var keys: Set<URLResourceKey>
    var url: URL
}

struct PlistDerivedData: Codable {
    let LastAccessedDate: Date?
    let WorkspacePath: String
}
