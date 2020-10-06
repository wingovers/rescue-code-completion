// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation
import AppKit

class AppKitSwiftUIFactory: ViewControllerFactory {


    init(using container: DependencyContainer) {
        self.restorer = container.restorer
        self.interactorApps = container.interactorApps
        self.interactorDirs = container.interactorDirs
        self.repoApps = container.repoApps
        self.repoRootDirs = container.repoRootDirs
        self.repoProjects = container.repoProjects
        self.repoPrefs = container.repoPrefs
        self.loginItemService = container.loginItemService
        self.windowManager = container.windowManager
    }

    private let restorer: RestoreCodeCompletionUseCase
    private let interactorApps: AppInteractor
    private let interactorDirs: DirectoryInteractor
    private let repoApps: AppsRepo
    private let repoRootDirs: RootDirectoriesRepo
    private let repoPrefs: PreferencesRepo
    private let repoProjects: ProjectDirectoriesRepo
    private let loginItemService: LoginItemService
    private let windowManager: WindowManagement


    // MARK: - Menu Bar
    func makeMenuBarPopoverViewHostingController() -> MenuBarPopoverViewHostingController {
        MenuBarPopoverViewHostingController(repoRootDirs)
    }

    func makeMenuButton(with popover: NSPopover) -> StatusBarController {
        StatusBarController(popover: popover,
                            repo: repoPrefs)
    }

    func setWindowActions(_ actions: Actions...) {
        actions.forEach { action in
            windowManager.set(action: action)
        }
    }

    // MARK: - Menu Bar Popover

    func makeOnboardingVM() -> OnboardingVM {
        OnboardingVM(actions: windowManager)
    }

    func makeMenuBarPopoverVM() -> MenuBarPopoverVM {
        MenuBarPopoverVM(apps: repoApps,
                         dirs: repoRootDirs)
    }

    func makeRootDirectoryVM(root: DerivedDataRootDirectory) -> RootDirectorySectionVM {
        RootDirectorySectionVM(root: root,
                        dirs: repoRootDirs,
                        prefs: repoPrefs)
    }

    func makeTempDirectoryVM(dir: DerivedDataTempDirectory,
                             root: UUID) -> TempDirectoryVM {
        TempDirectoryVM(dir: dir,
                        root: root,
                        repo: repoRootDirs,
                        restorer: restorer)
    }

    // MARK: - Menu Bar Popover Footer

    func makeQuitButtonVM() -> QuitButtonVM {
        QuitButtonVM()
    }

    func makePreferencesButtonVM() -> PreferencesButtonVM {
        PreferencesButtonVM(actions: windowManager)
    }

    func makeIDEButtonVM(ide: Xcode) -> IDEButtonVM {
        IDEButtonVM(apps: repoApps, app: ide)
    }

    // MARK: - Preferences Panel
    func makeUserSelectedContentColumnVM() -> UserSelectedContentColumnVM {
        UserSelectedContentColumnVM()
    }

    func makePrefsRootDirectoriesListVM() -> PrefsRootDirectoriesListVM {
        PrefsRootDirectoriesListVM(dirs: repoRootDirs)
    }

    func makePrefsIDEsListVM() -> PrefsIDEsListVM {
        PrefsIDEsListVM(appsRepo: repoApps)
    }

    func makePrefsProjectListVM() -> PrefsProjectListVM {
        PrefsProjectListVM(projects: repoProjects)
    }

    func makeImporterVM() -> ImporterVM {
        ImporterVM(apps: repoApps, dirs: repoRootDirs, projects: repoProjects)
    }

    func makeUserPreferencesColumnVM() -> UserPreferencesColumnVM {
        UserPreferencesColumnVM()
    }

    func makeMenuBarOptionsListVM() -> MenuBarOptionsListVM {
        MenuBarOptionsListVM(prefs: repoPrefs, login: loginItemService)
    }

    func makeDeleteOptionsListVM() -> DeleteOptionsListVM {
        DeleteOptionsListVM(prefs: repoPrefs)
    }


    // MARK: - Feedback Panel

    func makeFeedbackHelpVM() -> FeedbackHelpScreenVM {
        FeedbackHelpScreenVM()
    }

    func makeAboutColumnVM() -> AboutColumnVM {
        AboutColumnVM()
    }

    func makeFAQsVM() -> FAQsVM {
        FAQsVM()
    }

    func makeFeedbackSectionVM() -> FeedbackSectionVM {
        FeedbackSectionVM()
    }

    func makeFeedbackIconVM() -> FeedbackIconVM {
        FeedbackIconVM()
    }

}
