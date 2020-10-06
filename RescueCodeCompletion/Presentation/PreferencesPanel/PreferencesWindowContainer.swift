//
//  PreferencesWindowContainer.swift
 
//
//  Created by Ryan on 10/17/20.
//

import SwiftUI

protocol PreferencesWindowContainer {
    func open()
    func close()
}

class PreferencesWindow: PreferencesWindowContainer {
    init(factory: ViewControllerFactory) {
        self.factory = factory
    }
    weak var factory: ViewControllerFactory?
    private var window: PrefsWindow?

    private func setup() {
        guard let factory = factory else { return }
        window = PrefsWindow()
        guard let window = window else { return }
        window.contentView = NSHostingView(rootView: PreferencesFeedbackScreen(factory: factory))
        open()
    }

    func open() {
        if window == nil { setup() }
        else {
            window?.display()
            window?.orderFrontRegardless()
            window?.makeFirstResponder(nil)
        }
    }

    func close() {
        window?.performClose(nil)
    }
}

class PrefsWindow: NSWindow {
    init() {
        super.init(
            contentRect: NSRect(x: 0,
                                y: 0,
                                width: .preferencesMinWidth,
                                height: .preferencesMinHeight),
            styleMask: [.titled,
                        .unifiedTitleAndToolbar,
                        .resizable,
                        .closable,
                        .miniaturizable,
                        .fullSizeContentView],
            backing: .buffered,
            defer: false)

        acceptsMouseMovedEvents = true
        isMovableByWindowBackground = true
        isReleasedWhenClosed = false
        title = NSLocalizedString("preferences", comment: "window title")
        setFrameAutosaveName("Preferences")
        titlebarAppearsTransparent = true

        animateOpening()
    }

    func animateOpening() {
        alphaValue = 0
        center()
        let frame = self.frame
        let newFrame = NSRect(x: frame.origin.x,
                              y: frame.maxY - .preferencesWindowOpenRiseAnimationDistance,
                              width: 1, height: 1)
        setFrame(newFrame, display: true, animate: true)
        NSAnimationContext.runAnimationGroup { (context) in
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)
            animator().setFrame(frame, display: true, animate: true)
            animator().alphaValue = 1
        }
        minSize = NSSize(width: .preferencesMinWidth,
                                height: .preferencesMinHeight)

        let tracking = NSTrackingArea(rect: frame,
                       options: [.activeAlways, .mouseMoved, .inVisibleRect],
                       owner: self,
                       userInfo: nil)
        contentView?.addTrackingArea(tracking)
    }

    override func mouseMoved(with event: NSEvent) {
        makeKeyAndOrderFront(event)
    }
}
