// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

class TempDirectoriesPopulator {
    private let keys: [URLResourceKey] = [
        .contentAccessDateKey,
        .contentModificationDateKey,
        .isDirectoryKey,
        .isSymbolicLinkKey,
        .isAliasFileKey
    ]
}

extension TempDirectoriesPopulator: TempDirectoriesPopulating {
    func populateTemps(in root: URL) -> [DerivedDataTempDirectory] {
        let contents = enumerate(root)
        guard let urls = contents?.urls,
              let keys = contents?.keys else { return [DerivedDataTempDirectory]() }
        return urls.compactMap {
            detailTempDirectory(at: $0, with: keys)
        }
    }
}

private extension TempDirectoriesPopulator {
    func enumerate(_ directory: URL) -> FileManagerDirectoryContentsResult? {

        let fm = FileManager.default
        guard let urls = try? fm.contentsOfDirectory(at: directory,
                                                     includingPropertiesForKeys: keys,
                                                     options: [
                                                        .skipsHiddenFiles,
                                                        .skipsSubdirectoryDescendants,
                                                        .skipsPackageDescendants
                                                     ])
        else { return nil }
        return FileManagerDirectoryContentsResult(keys: Set(keys), urls: urls)
    }

    func detailTempDirectory(at url: URL, with keys: Set<URLResourceKey>) -> DerivedDataTempDirectory? {
        guard let values = try? url.resourceValues(forKeys: keys),
              let isDirectory = values.isDirectory,
              let isSymbolicLink = values.isSymbolicLink,
              let isAlias = values.isAliasFile,
              isDirectory,
              !isSymbolicLink,
              !isAlias
        else { return nil }

        let plist = getPlistForDirectory(url)
        let date = latestDate(from: values.contentModificationDate,
                              or: values.contentAccessDate,
                              xcode: plist.LastAccessedDate)
        let name = deriveName(from: plist, and: url)
        return DerivedDataTempDirectory(id: UUID(),
                                        url: url,
                                        name: name,
                                        updated: date,
                                        xcodeprojPath: validated(plist.WorkspacePath)
        )
    }

    private func getPlistForDirectory(_ url: URL) -> PlistDerivedData {
        let path = url
            .appendingPathComponent("info")
            .appendingPathExtension(for: .propertyList)
            .path
        guard FileManager.default.fileExists(atPath: path),
              let xml = FileManager.default.contents(atPath: path),
              let plist = try? PropertyListDecoder().decode(PlistDerivedData.self, from: xml)
        else {
            return PlistDerivedData(LastAccessedDate: nil, WorkspacePath: "")
        }
        return plist
    }

    private func deriveName(from plist: PlistDerivedData, and url: URL) -> String {
        if plist.WorkspacePath.isEmpty,
           isValid(plist.WorkspacePath) {
            return deriveNameFromPlistWorkspacePath(plist.WorkspacePath)
        } else {
            return deriveNameFromURL(url)
        }
    }

    private func isValid(_ workspacePath: String) -> Bool {
        let url = URL(fileURLWithPath: workspacePath)
        guard url.pathExtension == "xcodeproj" else { return false }
        return true
    }

    private func deriveNameFromPlistWorkspacePath(_ path: String) -> String {
        let url = URL(fileURLWithPath: path).deletingPathExtension()
        return url.lastPathComponent
    }

    private func dirIsLikelyXcodeTagged(rawName: String) -> Bool {
        guard rawName.count > 29 else { return false }
        let possibleHyphenFromTag = rawName.dropLast(28).last
        guard possibleHyphenFromTag == .some("-") else { return false }
        return true
    }

    private func deriveNameFromURL(_ url: URL) -> String {
        let dirName = url.deletingPathExtension().lastPathComponent
        let xcodeIdentifierTagLength = 29
        if dirIsLikelyXcodeTagged(rawName: dirName) {
            return String(dirName.dropLast(xcodeIdentifierTagLength))
        } else {
            return dirName
        }
    }

    private func latestDate(from date1: Date?, or date2: Date?, xcode: Date?) -> Date {
        if let xcode = xcode { return xcode }
        let date = Date(timeIntervalSince1970: 0)
        if let date1 = date1,
           let date2 = date2 {
            return max(date1,date2)
        } else {
            return min(date1 ?? date, date2 ?? date)
        }
    }

    private func validated(_ projectPath: String) -> String {
        let url = URL(fileURLWithPath: projectPath)
        return url.pathExtension == "xcodeproj"
            ? projectPath
            : ""
    }
}
