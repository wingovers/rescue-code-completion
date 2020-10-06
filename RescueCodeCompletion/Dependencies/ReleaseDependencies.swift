// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

class ReleaseDependencies: DependencyContainer {

    init() {
        let bookmarker = SSBookmarker()
        let tempDirPopulating = TempDirectoriesPopulator()
        let localPersistence = LocalJSONPersister()
        let windowManager = WindowManager()

        self.persistence = PersistenceCoordinator(local: localPersistence)
        self.repoApps = AppsRepository(persistence: persistence,
                                       bookmarker: bookmarker)
        self.repoRootDirs = RootDirectoriesRepository(persistence: persistence,
                                                     bookmarker: bookmarker,
                                                     tempPopulator: tempDirPopulating)
        self.repoPrefs = PreferencesRepository(persistence: persistence)
        self.repoProjects = ProjectDirectoriesRepository(persistence: persistence,
                                                         bookmarker: bookmarker)

        self.interactorApps = XcodeReopener(repo: repoApps)
        self.interactorDirs = DirectoryDeletor(directories: repoRootDirs,
                                               preferences: repoPrefs)

        self.restorer = CodeCompletionRestorer(opener: interactorApps,
                                               deletor: interactorDirs,
                                               preferences: repoPrefs)
        self.loginItemService = AlwaysOpenOnLogin(prefs: repoPrefs)
        self.windowManager = windowManager

        self.appTerminationRoutines =
            [
                repoApps.ceaseUsingSecurityScopedURLs,
                repoRootDirs.ceaseUsingSecurityScopedURLs,
                repoProjects.ceaseUsingSecurityScopedURLs
            ]
    }

    let persistence: PersistenceCoordinating
    let restorer: RestoreCodeCompletionUseCase
    let interactorApps: AppInteractor
    let interactorDirs: DirectoryInteractor
    let repoApps: AppsRepo
    let repoRootDirs: RootDirectoriesRepo
    let repoPrefs: PreferencesRepo
    let repoProjects: ProjectDirectoriesRepo
    let loginItemService: LoginItemService
    let windowManager: WindowManagement
    let appTerminationRoutines: [() -> Void]
}
