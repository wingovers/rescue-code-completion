// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

struct DerivedDataRootDirectory: Identifiable, Hashable  {
    var id: UUID
    var name: String
    var ssBookmark: Data
    var restoredURL: URL? = nil
    var tempDirectories: [DerivedDataTempDirectory] = [DerivedDataTempDirectory]()
    var isDefault: Bool

    var displayURL: String {
        restoredURL?.path ?? ""
    }
}

extension DerivedDataRootDirectory: Codable {
    enum CodingKeys: CodingKey {
        case id, name, ssBookmark, isDefault
    }
}
