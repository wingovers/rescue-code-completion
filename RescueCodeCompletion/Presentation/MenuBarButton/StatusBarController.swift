// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

import AppKit
import Combine

class StatusBarController {
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    private var eventMonitor: EventMonitor?
    private var subscriptions = Set<AnyCancellable>()
    let buttonImageSize = NSSize(width: .statusBarIconWidth,
                                 height: .statusBarIconHeight)

    init(popover: NSPopover, repo: PreferencesRepo) {
        self.popover = popover
        statusBar = NSStatusBar()
        statusItem = statusBar.statusItem(withLength: .statusBarItemLength)
        statusItem.behavior = .removalAllowed
        statusItem.behavior = .terminationOnRemoval

        setupStatusBarIcon(with: repo.menubarIcon)
        updateWithLatestStatusBarIcon(following: repo.menubarIconUpdates)

        eventMonitor = EventMonitor(mask: [.leftMouseDown,
                                           .rightMouseDown],
                                    handler: mouseEventHandler)
    }

    private func setupStatusBarIcon(with icon: MenubarIcon) {
        if let statusBarButton = statusItem.button {
            statusBarButton.image = NSImage(named: icon.xcasset)
            statusBarButton.image?.size = buttonImageSize
            statusBarButton.image?.isTemplate = true
            statusBarButton.action = #selector(togglePopover(sender:))
            statusBarButton.target = self
        }
    }

    private func updateWithLatestStatusBarIcon(following publisher: Published<MenubarIcon>.Publisher) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] icon in
                guard let self = self else { return }
                if let button = self.statusItem.button {
                    button.viewWillDraw()
                    button.image = NSImage(named: icon.xcasset)
                    button.image?.size = self.buttonImageSize
                    button.image?.isTemplate = true
                }
            }
            .store(in: &subscriptions)
    }

    @objc func togglePopover(sender: AnyObject) {
        if(popover.isShown) {
            hidePopover(sender)
        }
        else {
            showPopover(sender)
        }
    }

    func showPopover(_ sender: AnyObject) {
        if let statusBarButton = statusItem.button {
            popover.show(relativeTo: statusBarButton.bounds,
                         of: statusBarButton,
                         preferredEdge: NSRectEdge.maxY)
            eventMonitor?.start()
        }
    }

    func hidePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }

    func mouseEventHandler(_ event: NSEvent?) {
        if popover.isShown {
            hidePopover(event!)
        }
    }
}
