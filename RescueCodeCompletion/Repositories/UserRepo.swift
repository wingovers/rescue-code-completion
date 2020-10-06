//
//  Repository.swift
//  chimneysweep
//
//  Created by Ryan on 10/14/20.
//

import Foundation
import AppKit

class UserDataIteractor: Republisher, UserRepo {
    private let persistence: Persisting
    init(persistence: Persisting) {
        let data = persistence.loadData()
        rootDirectories = data.rootDirectories
        xcodeApps = data.xcodes
        preferences = data.preferences
        self.persistence = persistence
        self.menubarIcon = data.preferences.menubarIcon
        super.init()
        restoreUserData()
    }

    private var rootDirectories: [DerivedDataRootDirectory] {
        didSet {
            publish()
            persistence.persist(PersistRequest(rootDirectories: rootDirectories))
        }
    }

    private var xcodeApps: [Xcode] {
        didSet {
            publish()
            persistence.persist(PersistRequest(xcodes: xcodeApps))
        }
    }

    private var preferences: Preferences {
        didSet {
            publish()
            persistence.persist(PersistRequest(preferences: preferences))
        }
    }

    @Published private(set) var menubarIcon: MenubarIcon
    var menubarIconUpdates: Published<MenubarIcon>.Publisher { $menubarIcon }

    var liveRootDirectories: [DerivedDataRootDirectory] {
        rootDirectories.filter { $0.restoredURL != nil }
    }

    var liveXcodeApps: [Xcode] {
        xcodeApps.filter { $0.restoredURL != nil }
    }

    var deadRootDirectories: [DerivedDataRootDirectory] {
        print(#function)
        print(rootDirectories.filter { $0.restoredURL == nil })
        return rootDirectories.filter { $0.restoredURL == nil }
    }

    var deadXcodeApps: [Xcode] {
        print(#function)
        print(xcodeApps.filter { $0.restoredURL == nil })
        return xcodeApps.filter { $0.restoredURL == nil }
    }
}






// CRUD
extension UserDataIteractor {
    func add(_ type: TargetType, at url: URL) {
        guard let bookmark = createSecurityScopedBookmarkFor(url: url) else { return }
        switch type {
        case .Xcode:
            let isFirstDefault = xcodeApps.count == 0
            let name = url.deletingPathExtension().lastPathComponent
            let app = Xcode(id: UUID(),
                            name: name,
                            ssBookmark: bookmark,
                            restoredURL: url,
                            isDefault: isFirstDefault)
            xcodeApps.append(app)
            populateXcodeApps()
        case .RootDirectory:
            let isFirstDefault = rootDirectories.count == 0
            let name = url.deletingPathExtension().lastPathComponent
            let dir = DerivedDataRootDirectory(id: UUID(),
                                                  name: name,
                                                  ssBookmark: bookmark,
                                                  restoredURL: url,
                                                  isDefault: isFirstDefault)
            rootDirectories.append(dir)
            populateDerivedDataDirectories()
        }
    }

    /// Start accessing Xcode bookmarks, coordinate populating model with icon
    func populateXcodeApps() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            for xcode in self.xcodeApps.enumerated() {
                guard let app = xcode.element.restoredURL,
                      app.startAccessingSecurityScopedResource()
                else {
                    self.invalidateURLAfterError(for: .Xcode, id: xcode.element.id)
                    print(#function, "error")
                    return
                }
                guard let icon = self.getAppIcon(from: app) else { return }
                self.xcodeApps[xcode.offset].tempSetImage(icon)
            }
        }
    }

    /// Quit app: resign use of bookmarks
    func ceaseUsingSecurityScopedURLs() {
        rootDirectories.forEach { $0.restoredURL?.stopAccessingSecurityScopedResource()
        }
        xcodeApps.forEach { $0.restoredURL?.stopAccessingSecurityScopedResource()
        }
    }

    /// Stop monitoring a directory or App
    func unwatch(_ type: TargetType, id: UUID) {
        switch type {
        case .Xcode:
            guard let index = xcodeApps.firstIndex(where: { $0.id == id }) else { return }
            xcodeApps.remove(at: index)
        case .RootDirectory:
            guard let index = rootDirectories.firstIndex(where: { $0.id == id }) else { return }
            rootDirectories.remove(at: index)
        }
    }

    func rename(_ type: TargetType, id: UUID, to newName: String) {
        DispatchQueue.main.async { [self] in
            switch type {
            case .Xcode:
                guard let index = xcodeApps.firstIndex(where: { $0.id == id }) else { return }
                xcodeApps[index].name = newName
            case .RootDirectory:
                guard let index = rootDirectories.firstIndex(where: { $0.id == id }) else { return }
                rootDirectories[index].name = newName
            }
        }
    }

    /// Set the default Xcode or monitored directory
    func setDefault(_ type: TargetType, to id: UUID) {
        switch type {
        case .Xcode:
            for index in xcodeApps.indices {
                xcodeApps[index].isDefault = false
            }
            guard let targetIndex = xcodeApps.firstIndex(where: { $0.id == id }) else { return }
            xcodeApps[targetIndex].isDefault = true
        case .RootDirectory:
            for index in rootDirectories.indices {
                rootDirectories[index].isDefault = false
            }
            guard let targetIndex = rootDirectories.firstIndex(where: { $0.id == id }) else { return }
            rootDirectories[targetIndex].isDefault = true
        }
    }


}





extension UserDataIteractor {
    /// Set a user preference
    func setPreference(_ preference: Preferences.Preference, to newState: Bool) {
        preferences.current[preference] = newState
    }

    /// Get
    func currentPreference(for preference: Preferences.Preference) -> Bool {
        return preferences.current[preference] ?? preference.defaultSetting
    }

    /// Preference
    func setMenubarIcon(to icon: MenubarIcon) {
        preferences.menubarIcon = icon
        menubarIcon = icon
    }
}






// MAP TEMP DIRECTORIES
extension UserDataIteractor {

    /// Coordinate restoring security access to bookmarked folders and populating a model with their current contents
    func populateDerivedDataDirectories() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in self?.rootDirectories.forEach {
                guard let directory = $0.restoredURL,
                      directory.startAccessingSecurityScopedResource(),
                      let contents = self?.enumerate(directory)
                else {
                    self?.invalidateURLAfterError(for: .RootDirectory, id: $0.id)
                    return
                }
                self?.getDetailsForTempDirectoryContents(in: $0.id, with: contents)
            }
        }
    }

    /// Helper: Enumerate a directory's folder contents with specific details about them, ignoring symlinks
    private func enumerate(_ directory: URL) -> FileManagerDirectoryContentsResult? {
        let keys: [URLResourceKey] = [
            .contentAccessDateKey,
            .contentModificationDateKey,
            .isDirectoryKey,
            .isApplicationKey,
            .isSymbolicLinkKey,
            .isAliasFileKey
        ]
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

    /// Ask Finder for details about a directory's enumerated contents, populate the model with those details
    private func getDetailsForTempDirectoryContents(in root: UUID, with result: FileManagerDirectoryContentsResult) {
        guard let rootIndex = rootDirectories.firstIndex(where: { $0.id == root }) else { return }
        rootDirectories[rootIndex].tempDirectories.removeAll()
        result.urls.forEach { url in
            guard let values = try? url.resourceValues(forKeys: result.keys) else {
                invalidateURLAfterError(for: .RootDirectory, id: root)
                return
            }
            guard let isDirectory = values.isDirectory,
                  isDirectory,
                  let isSymbolicLink = values.isSymbolicLink,
                  !isSymbolicLink,
                  let isAlias = values.isAliasFile,
                  !isAlias
            else { return }

            let plist = getPlistForDirectory(url)
            let date = latestDate(from: values.contentModificationDate,
                                  or: values.contentAccessDate,
                                  xcode: plist.LastAccessedDate)
            let name = deriveName(from: plist, and: url)
            let directory = DerivedDataTempDirectory(id: UUID(),
                                                  url: url,
                                                  name: name,
                                                  updated: date,
                                                  xcodeprojPath: plist.WorkspacePath)

            DispatchQueue.main.async { [weak self] in
                self?.rootDirectories[rootIndex].tempDirectories.append(directory)
            }
        }
    }

    /// Helper: get name from plist or Finder (e.g., non-project folders)
    private func deriveName(from plist: PlistDerivedData, and url: URL) -> String {
        guard !plist.WorkspacePath.isEmpty else {
            return url.deletingPathExtension().lastPathComponent
        }
        let url = URL(fileURLWithPath: plist.WorkspacePath).deletingPathExtension()
        return url.lastPathComponent
    }

    /// Helper: assign stand-in date for a folder if date can't be determined from plist file
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

    /// Helper: get the plist for an Xcode temp derived data directory
    private func getPlistForDirectory(_ url: URL) -> PlistDerivedData {
        let path = url
            .appendingPathComponent("info")
            .appendingPathExtension("plist")
            .path
        guard FileManager.default.fileExists(atPath: path),
              let xml = FileManager.default.contents(atPath: path),
              let plist = try? PropertyListDecoder().decode(PlistDerivedData.self, from: xml)
              else {
            return PlistDerivedData(LastAccessedDate: nil, WorkspacePath: "")
        }
        return plist
    }
}




// SECURITY SCOPED URLS
private extension UserDataIteractor {

    /// Coodinate bookmark access and populating model with latest directory and app contents
    func restoreUserData() {
        restoreAccessToSSBookmarks { [weak self] in
            self?.populateDerivedDataDirectories()
            self?.populateXcodeApps()
        }
    }

    /// Ask Finder to restore access to bookmarks on app open
    func restoreAccessToSSBookmarks(completion: @escaping () -> Void) {
        DispatchQueue.global().async { [weak self] in
            self?.rootDirectories.enumerated().forEach {
                var isStale = false
                guard let url = try? URL(resolvingBookmarkData: $0.element.ssBookmark,
                                         options: .withSecurityScope,
                                         relativeTo: nil,
                                         bookmarkDataIsStale: &isStale)
                else { return }
                if isStale { self?.refreshSSBookmark(at: $0.offset, with: url) }
                self?.rootDirectories[$0.offset].restoredURL = url
            }
            self?.xcodeApps.enumerated().forEach {
                var isStale = false
                guard let url = try? URL(resolvingBookmarkData: $0.element.ssBookmark,
                                         options: .withSecurityScope,
                                         relativeTo: nil,
                                         bookmarkDataIsStale: &isStale),
                url.startAccessingSecurityScopedResource()
                else { print(#function, "error"); return }
                if isStale { self?.refreshSSBookmark(at: $0.offset, with: url) }
                self?.xcodeApps[$0.offset].restoredURL = url
            }
            completion()
        }
    }

    func createSecurityScopedBookmarkFor(url: URL) -> Data? {
        try? url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
    }

    /// When Finder says a bookmark is stale, get a new bookmark
    func refreshSSBookmark(at index: Int, with url: URL) {
        guard let newBookmark = createSecurityScopedBookmarkFor(url: url) else { return }
        rootDirectories[index].ssBookmark = newBookmark
    }

    /// Nil restored URL in model, prompting its display as a broken model folder
    func invalidateURLAfterError(for type: TargetType, id: UUID) {
        DispatchQueue.main.async { [weak self] in
            switch type {
            case .Xcode:
                guard let index = self?.xcodeApps.firstIndex(where: { $0.id == id }) else { return }
                self?.xcodeApps[index].restoredURL = nil
            case .RootDirectory:
                guard let index = self?.rootDirectories.firstIndex(where: { $0.id == id }) else { return }
                self?.rootDirectories[index].restoredURL = nil
            }
        }
    }

}




private extension UserDataIteractor {

    private func getAppIcon(from app: URL) -> NSImage? {
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
