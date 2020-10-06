// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

protocol DependencyContainer {
    var restorer: RestoreCodeCompletionUseCase { get }
    var interactorApps: AppInteractor { get }
    var interactorDirs: DirectoryInteractor { get }
    var repoApps: AppsRepo { get }
    var repoRootDirs: RootDirectoriesRepo { get }
    var repoPrefs: PreferencesRepo { get }
    var repoProjects: ProjectDirectoriesRepo { get }
    var loginItemService: LoginItemService { get }
    var windowManager: WindowManagement { get }
    var appTerminationRoutines: [() -> Void] { get }
}
