
import Foundation

enum TargetType {
    case Xcode, RootDirectory
}

protocol UserRepo: Republisher {
    var liveRootDirectories: [DerivedDataRootDirectory] { get }
    var deadRootDirectories: [DerivedDataRootDirectory]  { get }
    var liveXcodeApps: [Xcode]  { get }
    var deadXcodeApps: [Xcode]  { get }
    var menubarIcon: MenubarIcon { get }
    var menubarIconUpdates: Published<MenubarIcon>.Publisher { get }
    func setMenubarIcon(to icon: MenubarIcon)

    func populateDerivedDataDirectories()
    func add(_ type: TargetType, at url: URL)
    func unwatch(_ type: TargetType, id: UUID)
    func rename(_ type: TargetType, id: UUID, to newName: String)
    func eradicateTempDirectory(_ id: UUID, in root: UUID, completion: @escaping (Bool) -> Void)
    func setDefault(_ type: TargetType, to id: UUID)
    func setPreference(_ preference: Preferences.Preference, to newState: Bool)
    func currentPreference(for preference: Preferences.Preference) -> Bool
    func ceaseUsingSecurityScopedURLs()
}
