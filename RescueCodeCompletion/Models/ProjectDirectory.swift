// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

struct ProjectDirectory: Identifiable, Hashable  {
    var id: UUID
    var name: String
    var ssBookmark: Data
    var restoredURL: URL? = nil

    var displayURL: String {
        restoredURL?.path ?? ""
    }
}

extension ProjectDirectory: Codable {
    enum CodingKeys: CodingKey {
        case id, name, ssBookmark
    }
}
