// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

enum PlistValidity: String {
    case valid = "Valid Plist"
    case invalidPathExtension = "Invalid Path Extension Plist"
    case invalidKey = "Invalid Key Plist"
    case absent = "Absent Plist"

    func infoPlist(name: String) -> String {
        switch self {
            case .valid:
                return validInfoPlist(test: name)
            case .invalidPathExtension:
                return invalidPlistPathExtension(test: name)
            case .invalidKey:
                return invalidPlistKey(test: name)
            case .absent:
                return absentPlist(test: name)
        }
    }


}

private extension PlistValidity {
    func validInfoPlist(test: String) -> String {
        """
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>LastAccessedDate</key>
        <date>2020-11-02T01:24:31Z</date>
        <key>WorkspacePath</key>
        <string>/Users/ryan/Developer/A\(test)/B\(test)/\(test).xcodeproj</string>
    </dict>
    </plist>
    """
    }

    func absentPlist(test: String) -> String {
        ""
    }

    // Broken: last letter of path extension + flagged project name with prefix "Invalid"
    func invalidPlistPathExtension(test: String) -> String {
        """
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>LastAccessedDate</key>
        <date>2020-11-02T01:24:31Z</date>
        <key>WorkspacePath</key>
        <string>Invalid \(test).xcodepro</string>
    </dict>
    </plist>
    """
    }

    // Broken: key renamed to "Invalid Key"
    func invalidPlistKey(test: String) -> String {
        """
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>LastAccessedDate</key>
        <date>2020-11-02T01:24:31Z</date>
        <key>InvalidKey</key>
        <string>/Users/ryan/Developer/A\(test)/B\(test)/\(test).xcodeproj</string>
    </dict>
    </plist>
    """
    }
}
