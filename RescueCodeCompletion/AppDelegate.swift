// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    override init() {
        let dependencies = ReleaseDependencies()
        self.factory = AppKitSwiftUIFactory(using: dependencies)
        self.loginItemService = dependencies.loginItemService
        self.appTerminationRoutines = dependencies.appTerminationRoutines
        self.menuPopover = NSPopover()
    }
    let factory: ViewControllerFactory
    let loginItemService: LoginItemService
    let appTerminationRoutines: [() -> Void]

    var menuPopover: NSPopover
    var menuButton: StatusBarController?
    var preferencesWindow: PreferencesWindowContainer?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupPreferencesWindow()
        setupMenuBar()
        setupWindowManagement()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        appTerminationRoutines.forEach { $0() }
    }
}

private extension AppDelegate {

    func setupPreferencesWindow() {
        preferencesWindow = PreferencesWindow(factory: factory)
    }

    func setupMenuBar() {
        let swiftUIPopover = MenuBarPopoverView(factory: factory)
        menuPopover.contentViewController = factory.makeMenuBarPopoverViewHostingController()
        menuPopover.contentViewController?.view = NSHostingView(rootView: swiftUIPopover)
        menuButton = factory.makeMenuButton(with: menuPopover)
    }

    func setupWindowManagement() {
        guard let preferencesWindow = preferencesWindow else {
            setupPreferencesWindow()
            setupWindowManagement()
            return
        }
        factory.setWindowActions(
            .menuBarPopoverClose(menuPopover.performClose(_:)),
            .preferencesClose(preferencesWindow.close),
            .preferencesOpen(preferencesWindow.open)
        )
    }
}
