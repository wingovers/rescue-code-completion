// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

struct TempDir {
    let test: String

    let plist: PlistValidity

    var answerName: String {
        test
    }

    var answerXcodeProjectPath: String {
        switch plist {
            case .valid:
                return "/Users/ryan/Developer/A\(test)/B\(test)/\(test).xcodeproj"
            case .invalidPathExtension:
                return ""
            case .invalidKey:
                return ""
            case .absent:
                return ""
        }
    }

    var answerDate: Date {
        let builtInDate = DateComponents(calendar: .current, year: 2020, month: 11, day: 02, hour: 01, minute: 24, second: 31).date!
        let zoneAdjustment = Double(TimeZone.current.secondsFromGMT())
        let adjustedDate = builtInDate.addingTimeInterval(zoneAdjustment)
        switch plist {
            case .valid:
                return adjustedDate
            case .invalidPathExtension:
                return adjustedDate
            case .invalidKey:
                return Date()
            case .absent:
                return Date()
        }
    }

    var tempFolderName: String {
        test.appending(tempDirSuffix())
    }

    var infoPlist: String {
        plist.infoPlist(name: test)
    }

    func tempDirSuffix() -> String {
        let randomCharacterCount = 28
        let chars = "abcdefghijklmnopqrstuvwxyz"
        var suffix = ""
        for _ in 1...randomCharacterCount {
            suffix.append(chars.randomElement()!)
        }
        return "-".appending(suffix)
    }
}

