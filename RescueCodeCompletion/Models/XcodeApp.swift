// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation
import AppKit

struct Xcode: Identifiable, Hashable {
    var id: UUID
    var name: String
    var ssBookmark: Data
    var restoredURL: URL? = nil
    var isDefault: Bool
    private(set) var icon: NSImage? = nil

    var displayURL: String {
        restoredURL?.path ?? ""
    }

    mutating func tempSetImage(_ image: NSImage) {
        icon = image
    }
}

extension Xcode: Codable {
    enum CodingKeys: CodingKey {
        case id, name, ssBookmark, isDefault
    }
}
