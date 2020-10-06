// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation
import AppKit

protocol ViewControllerFactory: AnyObject {
    func makeMenuBarPopoverViewHostingController() -> MenuBarPopoverViewHostingController
    func makeMenuButton(with popover: NSPopover) -> StatusBarController
    func setWindowActions(_ actions: Actions...)

    func makeOnboardingVM() -> OnboardingVM
    func makeMenuBarPopoverVM() -> MenuBarPopoverVM
    func makeRootDirectoryVM(root: DerivedDataRootDirectory) -> RootDirectorySectionVM
    func makeTempDirectoryVM(dir: DerivedDataTempDirectory,
                             root: UUID) -> TempDirectoryVM

    func makeIDEButtonVM(ide: Xcode) -> IDEButtonVM
    func makePreferencesButtonVM() -> PreferencesButtonVM
    func makeQuitButtonVM() -> QuitButtonVM

    func makeUserSelectedContentColumnVM() -> UserSelectedContentColumnVM
    func makePrefsRootDirectoriesListVM() -> PrefsRootDirectoriesListVM
    func makePrefsIDEsListVM() -> PrefsIDEsListVM
    func makePrefsProjectListVM() -> PrefsProjectListVM
    func makeImporterVM() -> ImporterVM
    func makeUserPreferencesColumnVM() -> UserPreferencesColumnVM
    func makeMenuBarOptionsListVM() -> MenuBarOptionsListVM
    func makeDeleteOptionsListVM() -> DeleteOptionsListVM

    func makeFeedbackHelpVM() -> FeedbackHelpScreenVM
    func makeAboutColumnVM() -> AboutColumnVM
    func makeFAQsVM() -> FAQsVM
    func makeFeedbackSectionVM() -> FeedbackSectionVM
    func makeFeedbackIconVM() -> FeedbackIconVM
}


